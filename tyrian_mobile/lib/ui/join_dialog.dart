import 'package:flutter/material.dart';

import '../net/coop_host.dart';
import '../net/discovery.dart';

/// Lists the co-op hosts Bonjour finds on the local network; tapping one
/// connects. The joiner needs nothing from the host but the same Wi-Fi.
///
/// Typing an address stays available underneath for what Bonjour cannot
/// reach: a denied local-network permission, a router that keeps mDNS from
/// crossing between clients, Linux without Avahi.
class JoinDialog extends StatefulWidget {
  final CoopDiscovery discovery;
  final void Function(String address, int port) onConnect;

  const JoinDialog({super.key, required this.discovery, required this.onConnect});

  @override
  State<JoinDialog> createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
  final _ip = TextEditingController();
  bool _manual = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.discovery.onHostsChanged = () {
      if (mounted) setState(() {});
    };
    _browse();
  }

  Future<void> _browse() async {
    try {
      await widget.discovery.browse();
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
    widget.discovery.onHostsChanged = null;
    _ip.dispose();
    super.dispose();
  }

  void _connectTyped() {
    final ip = _ip.text.trim();
    if (ip.isNotEmpty) widget.onConnect(ip, CoopHost.defaultPort);
  }

  @override
  Widget build(BuildContext context) {
    final hosts = widget.discovery.hosts;
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.cyanAccent),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Looking for hosts on this Wi-Fi…',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            for (final host in hosts)
              InkWell(
                onTap: () => widget.onConnect(host.address, host.port),
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
                              '${host.address}:${host.port}',
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
