import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'channel.dart';
import 'protocol.dart';

/// Co-op client: sends input, receives snapshots — over a [CoopChannel] of
/// any kind. [connect] opens the LAN one itself; a Multipeer channel is
/// handed in through [attach] once the session is up.
class CoopClient {
  CoopChannel? _channel;
  StreamSubscription<Uint8List>? _sub;
  final MessageFramer _framer = MessageFramer();

  bool get isConnected => _channel != null;

  // Latest snapshot received from host (client reads this each frame)
  GameSnapshot? latestSnapshot;

  // Callbacks
  void Function(String hostPilotName)? onConnected;
  void Function()? onDisconnected;
  void Function(int eventType, double x, double y, String text)? onGameEvent;
  void Function(Uint8List payload)? onShopState;

  /// Connect to a host on the LAN.
  Future<bool> connect(String host, int port, String pilotName) async {
    print('Client: connecting to $host:$port');
    try {
      final socket = await Socket.connect(host, port,
          timeout: const Duration(seconds: 5));
      attach(SocketChannel(socket), pilotName);
      return true;
    } catch (e) {
      print('Client: connect failed: $e');
      return false;
    }
  }

  /// Use an already-open channel and introduce ourselves.
  void attach(CoopChannel channel, String pilotName) {
    _channel = channel;
    _sub = channel.data.listen(
      _onData,
      onDone: _onDone,
      onError: (_) => _onDone(),
      cancelOnError: false,
    );
    channel.send(encodeLobbyHandshake(pilotName));
    print('Client: connected (${channel.label})');
  }

  void _onData(Uint8List data) {
    final messages = _framer.addData(data);
    for (final (type, payload) in messages) {
      try {
        switch (type) {
          case MsgType.gameStateSnapshot:
            latestSnapshot = decodeGameSnapshot(payload);

          case MsgType.lobbyHandshake:
            final hs = decodeLobbyHandshake(payload);
            onConnected?.call(hs.pilotName);

          case MsgType.gameEvent:
            final ev = decodeGameEvent(payload);
            onGameEvent?.call(ev.eventType, ev.x, ev.y, ev.text);

          case MsgType.shopState:
            onShopState?.call(payload);
        }
      } catch (e) {
        print('CoopClient._onData error: $e');
      }
    }
  }

  void _onDone() {
    if (_channel == null) return;
    _sub = null;
    _channel = null;
    onDisconnected?.call();
  }

  /// Send player input to host (called every frame)
  void sendInput(double dx, double dy, bool fire) {
    _channel?.send(encodeClientInput(dx, dy, fire));
  }

  /// Send ready signal to host
  void sendReady() {
    _channel?.send(encodeReadySignal());
  }

  /// Send shop action to host
  void sendShopAction(int action, String weaponName, int slot) {
    _channel?.send(encodeShopAction(action, weaponName, slot));
  }

  /// Disconnect from host
  Future<void> dispose() async {
    final channel = _channel;
    _channel = null;
    await _sub?.cancel();
    _sub = null;
    await channel?.close();
  }
}
