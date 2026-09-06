import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// A peer seen while browsing.
class MultipeerPeer {
  final String id;
  final String name;
  final Map<String, String> info;
  const MultipeerPeer({required this.id, required this.name, required this.info});
}

enum MultipeerPeerState { connecting, connected, disconnected }

sealed class MultipeerEvent {
  const MultipeerEvent();
}

class MultipeerPeerFound extends MultipeerEvent {
  final MultipeerPeer peer;
  const MultipeerPeerFound(this.peer);
}

class MultipeerPeerLost extends MultipeerEvent {
  final String id;
  const MultipeerPeerLost(this.id);
}

class MultipeerPeerStateChanged extends MultipeerEvent {
  final String id;
  final String name;
  final MultipeerPeerState state;
  const MultipeerPeerStateChanged(this.id, this.name, this.state);
}

class MultipeerData extends MultipeerEvent {
  final String id;
  final Uint8List data;
  const MultipeerData(this.id, this.data);
}

class MultipeerError extends MultipeerEvent {
  final String message;
  const MultipeerError(this.message);
}

/// Dart face of the Multipeer Connectivity plugin: one session per app.
///
/// Apple-only by nature — Multipeer has no counterpart that talks to it on
/// Android or Windows. [isSupported] gates every call; on other platforms
/// the method channel would throw MissingPluginException.
class MultipeerCoop {
  MultipeerCoop._();
  static final MultipeerCoop instance = MultipeerCoop._();

  static bool get isSupported => Platform.isIOS || Platform.isMacOS;

  static const _methods = MethodChannel('multipeer_coop/methods');
  static const _events = EventChannel('multipeer_coop/events');

  Stream<MultipeerEvent>? _stream;

  /// Broadcast stream of everything the native side reports.
  Stream<MultipeerEvent> get events =>
      _stream ??= _events.receiveBroadcastStream().map(_parse);

  /// Advertise this device as a joinable host under [name].
  Future<void> startAdvertising(String name, Map<String, String> info) =>
      _methods.invokeMethod('startAdvertising', {'name': name, 'info': info});

  Future<void> stopAdvertising() => _methods.invokeMethod('stopAdvertising');

  /// Look for advertising hosts. Keep browsing until a peer reaches
  /// [MultipeerPeerState.connected] — stopping earlier drops the invitation.
  Future<void> startBrowsing(String name) =>
      _methods.invokeMethod('startBrowsing', {'name': name});

  Future<void> stopBrowsing() => _methods.invokeMethod('stopBrowsing');

  /// Ask a found host for its seat; the answer arrives as a state event.
  Future<void> invite(String peerId) =>
      _methods.invokeMethod('invite', {'peerId': peerId});

  /// Reliable, ordered delivery to one connected peer.
  Future<void> send(String peerId, Uint8List data) =>
      _methods.invokeMethod('send', {'peerId': peerId, 'data': data});

  /// Tear the whole session down: advertising, browsing and any connection.
  Future<void> disconnect() => _methods.invokeMethod('disconnect');

  static MultipeerEvent _parse(dynamic raw) {
    final m = (raw as Map).cast<String, dynamic>();
    final id = m['id'] as String? ?? '';
    switch (m['type']) {
      case 'found':
        final info = ((m['info'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k.toString(), v.toString()));
        return MultipeerPeerFound(
            MultipeerPeer(id: id, name: m['name'] as String? ?? id, info: info));
      case 'lost':
        return MultipeerPeerLost(id);
      case 'state':
        final state = switch (m['state']) {
          'connected' => MultipeerPeerState.connected,
          'connecting' => MultipeerPeerState.connecting,
          _ => MultipeerPeerState.disconnected,
        };
        return MultipeerPeerStateChanged(id, m['name'] as String? ?? id, state);
      case 'data':
        return MultipeerData(id, m['data'] as Uint8List);
      default:
        return MultipeerError(m['message'] as String? ?? 'unknown event');
    }
  }
}
