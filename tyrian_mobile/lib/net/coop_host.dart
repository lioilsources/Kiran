import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'channel.dart';
import 'protocol.dart';

/// Co-op host: one seat, filled over whatever transport delivered the
/// client — the TCP listener this class runs on the LAN, or a Multipeer
/// session handed in through [attach]. The game only ever sees the seat.
class CoopHost {
  static const int defaultPort = 5743;

  ServerSocket? _server;
  CoopChannel? _client;
  StreamSubscription<Uint8List>? _clientSub;
  MessageFramer _framer = MessageFramer();

  int get port => _server?.port ?? 0;
  bool get hasClient => _client != null;
  bool get isRunning => _server != null;

  // Callbacks
  void Function(double dx, double dy, bool fire)? onClientInput;
  Future<void> Function(String pilotName)? onClientConnected;
  void Function()? onClientDisconnected;
  void Function()? onClientReady;
  void Function(int action, int slot, String weaponName)? onShopAction;

  /// Sent back in the lobby handshake so the client can show who it joined.
  String hostPilotName = 'Host';

  /// Start the LAN listener on the fixed port (random if busy).
  Future<int> start(String hostPilotName) async {
    this.hostPilotName = hostPilotName;
    try {
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, defaultPort);
    } catch (_) {
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    }
    _server!.listen((socket) => attach(SocketChannel(socket)));
    print('Host: TCP server on port ${_server!.port}');
    return _server!.port;
  }

  /// Seat a client that arrived over any transport. The seat is single:
  /// a second arrival is closed straight away.
  void attach(CoopChannel channel) {
    if (_client != null) {
      channel.close();
      return;
    }
    print('Host: client attached (${channel.label})');
    _client = channel;
    // A fresh framer per client: the old one may hold half a frame from a
    // peer that dropped mid-message, and there is no way to flush it.
    _framer = MessageFramer();
    _clientSub = channel.data.listen(
      _onData,
      onDone: _onClientDone,
      onError: (_) => _onClientDone(),
      cancelOnError: false,
    );
  }

  Future<void> _onData(Uint8List data) async {
    final messages = _framer.addData(data);
    for (final (type, payload) in messages) {
      try {
        switch (type) {
          case MsgType.clientInput:
            final input = decodeClientInput(payload);
            onClientInput?.call(input.dx, input.dy, input.fire);

          case MsgType.lobbyHandshake:
            final hs = decodeLobbyHandshake(payload);
            // Send our handshake back
            _client?.send(encodeLobbyHandshake(hostPilotName));
            await onClientConnected?.call(hs.pilotName);

          case MsgType.readySignal:
            onClientReady?.call();

          case MsgType.shopAction:
            final sa = decodeShopAction(payload);
            onShopAction?.call(sa.action, sa.slot, sa.weaponName);
        }
      } catch (e) {
        print('CoopHost._onData error: $e');
      }
    }
  }

  void _onClientDone() {
    if (_client == null) return;
    _clientSub = null;
    _client = null;
    onClientDisconnected?.call();
  }

  /// Send a pre-encoded framed message to the client
  void send(Uint8List framedMessage) {
    _client?.send(framedMessage);
  }

  /// Send game state snapshot (already framed by protocol.dart)
  void sendSnapshot(Uint8List framedSnapshot) {
    _client?.send(framedSnapshot);
  }

  /// Send a game event to client
  void sendEvent(int eventType, {double x = 0, double y = 0, String text = ''}) {
    _client?.send(encodeGameEvent(eventType, x: x, y: y, text: text));
  }

  /// Shut down the listener and drop the client
  Future<void> dispose() async {
    final client = _client;
    _client = null;
    await _clientSub?.cancel();
    _clientSub = null;
    await client?.close();
    await _server?.close();
    _server = null;
  }
}
