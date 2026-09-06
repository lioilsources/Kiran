import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:multipeer_coop/multipeer_coop.dart';

/// A reliable, ordered byte pipe to one peer. `CoopHost` and `CoopClient`
/// speak their framed protocol over this and never see what carries it —
/// a TCP socket on the LAN, or a Multipeer session between nearby Apple
/// devices with no network in common.
abstract class CoopChannel {
  /// Bytes from the peer, in order. Done once the peer is gone.
  Stream<Uint8List> get data;

  void send(Uint8List bytes);

  Future<void> close();

  /// For logs: `tcp 192.168.1.7`, `nearby Ace`.
  String get label;
}

class SocketChannel implements CoopChannel {
  final Socket _socket;

  SocketChannel(this._socket) {
    _socket.setOption(SocketOption.tcpNoDelay, true);
  }

  @override
  Stream<Uint8List> get data => _socket;

  @override
  void send(Uint8List bytes) => _socket.add(bytes);

  @override
  Future<void> close() async => _socket.destroy();

  @override
  String get label => 'tcp ${_socket.remoteAddress.address}';
}

/// One connected Multipeer peer. The session itself belongs to
/// [MultipeerCoop.instance] and outlives this channel: closing here only
/// stops listening, because a host that just lost its client wants the same
/// session back for the next one.
class MultipeerChannel implements CoopChannel {
  final MultipeerCoop _mc;
  final String peerId;
  final String peerName;
  final _controller = StreamController<Uint8List>();
  late final StreamSubscription<MultipeerEvent> _events;

  MultipeerChannel(this._mc, this.peerId, this.peerName) {
    _events = _mc.events.listen((e) {
      switch (e) {
        case MultipeerData(:final id, :final data) when id == peerId:
          if (!_controller.isClosed) _controller.add(data);
        case MultipeerPeerStateChanged(:final id, :final state)
            when id == peerId && state == MultipeerPeerState.disconnected:
          if (!_controller.isClosed) _controller.close();
        default:
          break;
      }
    });
  }

  @override
  Stream<Uint8List> get data => _controller.stream;

  @override
  void send(Uint8List bytes) {
    _mc.send(peerId, bytes).catchError((Object e) {
      // The peer dropped between two frames; the state event closes us.
    });
  }

  @override
  Future<void> close() async {
    await _events.cancel();
    if (!_controller.isClosed) await _controller.close();
  }

  @override
  String get label => 'nearby $peerName';
}
