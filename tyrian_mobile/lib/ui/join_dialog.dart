import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multipeer_coop/multipeer_coop.dart';

import '../net/coop_host.dart';
import '../net/discovery.dart';

/// One list of every co-op host the device can reach: players on the same
/// Wi-Fi (Bonjour) and, on iPhone, iPad and Mac, players nearby with no
/// network in common (Multipeer). Tapping one connects.
///
/// Typing an address stays available underneath for what neither path
/// covers: a denied permission, a router that keeps mDNS from crossing
/// between clients, Linux without Avahi.
class JoinDialog extends StatefulWidget {
  final CoopDiscovery discovery;
  final String pilotName;
  final void Function(CoopHostInfo host) onJoin;

  const JoinDialog({
    super.key,
    required this.discovery,
    required this.pilotName,
    required this.onJoin,
  });

  @override
  State<JoinDialog> createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
  final _ip = TextEditingController();
  Timer? _slowTimer;
  bool _manual = false;
  bool _slow = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.discovery.onHostsChanged = () {
      if (mounted) setState(() {});
    };
    // Every failure gets a visible reason: after a few empty seconds say
    // what discovery needs, instead of spinning forever.
    _slowTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _slow = true);
    });
    _browse();
  }

  Future<void> _browse() async {
    try {
      await widget.discovery.browse(widget.pilotName);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Cannot search this network';
        _manual = true;
      });
    }
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    widget.discovery.onHostsChanged = null;
    _ip.dispose();
    super.dispose();
  }

  void _connectTyped() {
    final ip = _ip.text.trim();
    if (ip.isEmpty) return;
    widget.onJoin(CoopHostInfo(name: ip, address: ip, port: CoopHost.defaultPort));
  }

  @override
  Widget build(BuildContext context) {
    final hosts = widget.discovery.hosts;
    final nearbyHint = MultipeerCoop.isSupported
        ? 'Same Wi-Fi works on every device. iPhone, iPad and Mac also find each other nearby without one — with Personal Hotspot off on both.'
        : 'Both players must be on the same Wi-Fi — a Personal Hotspot works too.';
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Join co-op', style: TextStyle(color: Colors.cyanAccent)),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hosts.isEmpty && _error == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.cyanAccent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _slow
                            ? 'No hosts yet. $nearbyHint'
                            : 'Looking for hosts on this Wi-Fi and nearby…',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            for (final host in hosts)
              InkWell(
                onTap: () => widget.onJoin(host),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              host.name,
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              host.isNearby
                                  ? 'Nearby · Bluetooth / peer-to-peer Wi-Fi'
                                  : '${host.address}:${host.port} · same Wi-Fi',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            if (!_manual)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _manual = true),
                  child: const Text('Enter IP manually',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
              )
            else
              TextField(
                controller: _ip,
                autofocus: hosts.isEmpty,
                keyboardType: TextInputType.url,
                onSubmitted: (_) => _connectTyped(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: '192.168.x.x',
                  hintStyle: TextStyle(color: Colors.white38),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
        ),
        if (_manual)
          TextButton(
            onPressed: _connectTyped,
            child: const Text('CONNECT', style: TextStyle(color: Colors.cyanAccent)),
          ),
      ],
    );
  }
}
