import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/net/channel.dart';
import 'package:tyrian_mobile/net/coop_client.dart';
import 'package:tyrian_mobile/net/coop_host.dart';
import 'package:tyrian_mobile/net/protocol.dart';

/// In-memory pipe: what one end sends, the other receives. Stands in for
/// TCP and Multipeer alike — the whole point of [CoopChannel] is that the
/// host and client cannot tell the difference.
class MemoryChannel implements CoopChannel {
  final StreamController<Uint8List> _in = StreamController<Uint8List>();
  late MemoryChannel _peer;
  bool closed = false;

  static (MemoryChannel, MemoryChannel) pair() {
    final a = MemoryChannel();
    final b = MemoryChannel();
    a._peer = b;
    b._peer = a;
    return (a, b);
  }

  @override
  Stream<Uint8List> get data => _in.stream;

  @override
  void send(Uint8List bytes) {
    if (!_peer._in.isClosed) _peer._in.add(bytes);
  }

  @override
  Future<void> close() async {
    closed = true;
    if (!_in.isClosed) await _in.close();
    if (!_peer._in.isClosed) await _peer._in.close();
  }

  @override
  String get label => 'memory';
}

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  test('host and client shake hands over a transport-agnostic channel', () async {
    final (hostEnd, clientEnd) = MemoryChannel.pair();
    final host = CoopHost()..hostPilotName = 'Base';
    final client = CoopClient();

    String? seenByHost;
    String? seenByClient;
    host.onClientConnected = (name) async => seenByHost = name;
    client.onConnected = (name) => seenByClient = name;

    host.attach(hostEnd);
    client.attach(clientEnd, 'Ace');
    await settle();

    expect(host.hasClient, isTrue);
    expect(seenByHost, 'Ace');
    expect(seenByClient, 'Base');
  });

  test('the seat is single: a second arrival is closed, the first keeps playing', () async {
    final (hostEnd, clientEnd) = MemoryChannel.pair();
    final (lateEnd, _) = MemoryChannel.pair();
    final host = CoopHost();
    final client = CoopClient();

    host.attach(hostEnd);
    client.attach(clientEnd, 'Ace');
    await settle();
    host.attach(lateEnd);
    await settle();

    expect(lateEnd.closed, isTrue);
    expect(hostEnd.closed, isFalse);
    expect(host.hasClient, isTrue);

    var inputs = 0;
    host.onClientInput = (dx, dy, fire) => inputs++;
    client.sendInput(1, 0, true);
    await settle();
    expect(inputs, 1, reason: 'the first client is still the one being heard');
  });

  test('frames survive arbitrary chunking, as they must over a byte stream', () async {
    final (hostEnd, clientEnd) = MemoryChannel.pair();
    final host = CoopHost();
    final received = <(double, double, bool)>[];
    host.onClientInput = (dx, dy, fire) => received.add((dx, dy, fire));
    host.attach(hostEnd);

    // Two inputs in one buffer, delivered in three uneven pieces.
    final a = encodeClientInput(0.5, -0.25, true);
    final b = encodeClientInput(-1, 1, false);
    final all = Uint8List.fromList([...a, ...b]);
    clientEnd.send(Uint8List.sublistView(all, 0, 3));
    clientEnd.send(Uint8List.sublistView(all, 3, a.length + 2));
    clientEnd.send(Uint8List.sublistView(all, a.length + 2));
    await settle();

    expect(received, [(0.5, -0.25, true), (-1.0, 1.0, false)]);
  });

  test('a peer that goes away frees the seat once, and the client hears it', () async {
    final (hostEnd, clientEnd) = MemoryChannel.pair();
    final host = CoopHost();
    final client = CoopClient();
    var hostSaw = 0;
    var clientSaw = 0;
    host.onClientDisconnected = () => hostSaw++;
    client.onDisconnected = () => clientSaw++;

    host.attach(hostEnd);
    client.attach(clientEnd, 'Ace');
    await settle();
    await clientEnd.close();
    await settle();

    expect(host.hasClient, isFalse);
    expect(client.isConnected, isFalse);
    expect(hostSaw, 1);
    expect(clientSaw, 1);
  });
}
