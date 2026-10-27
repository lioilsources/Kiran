import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/net/coop_client.dart';

/// A failed LAN join must say why, so the JOIN flow can show it instead of
/// silently falling back to hosting.
void main() {
  test('a refused connect reports a reason', () async {
    // Bind and close a port so nothing is listening on it.
    final probe = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = probe.port;
    await probe.close();

    final client = CoopClient();
    final ok = await client.connect('127.0.0.1', port, 'Tester');
    expect(ok, isFalse);
    expect(client.lastError, isNotNull);
    expect(client.lastError, isNotEmpty);
  });
}
