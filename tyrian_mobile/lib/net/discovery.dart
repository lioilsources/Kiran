import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

/// A co-op host advertised on the local network.
class CoopHostInfo {
  /// The pilot name the host advertises under.
  final String name;

  /// IPv4 when the platform offers one; otherwise whatever it resolved to.
  final String address;
  final int port;

  const CoopHostInfo({required this.name, required this.address, required this.port});
}

/// Bonjour (DNS-SD over mDNS) discovery for co-op.
///
/// This used to be a raw UDP beacon: broadcast to 255.255.255.255 and a
/// multicast group, sent and received from a plain datagram socket. Since
/// iOS 14 either of those needs the `com.apple.developer.networking.multicast`
/// entitlement, which Apple grants per app on request — without it `sendto()`
/// fails with "No route to host" and the beacon never leaves the device. The
/// join screen fell back to asking for an IP, which the host screen showed in
/// a corner most players never found.
///
/// Bonjour is what Apple exempts from that entitlement: the request goes
/// through the system resolver (NWListener/NWBrowser on iOS and macOS,
/// NsdManager on Android, DNS-SD on Windows, Avahi on Linux) and the only
/// requirement is `NSBonjourServices` + `NSLocalNetworkUsageDescription` in the
/// Runner Info.plists. A host is listed only while it has a free seat: the
/// service is withdrawn when a client connects and re-advertised when it
/// leaves, so the join list never offers a full game.
class CoopDiscovery {
  /// Must match the `NSBonjourServices` entry in `ios/Runner/Info.plist` and
  /// `macos/Runner/Info.plist`, or the system silently refuses to browse.
  static const serviceType = '_tyriancoop._tcp';

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _events;

  /// Resolved hosts keyed by advertised service name.
  final Map<String, CoopHostInfo> _hosts = {};

  /// Called whenever [hosts] changes.
  void Function()? onHostsChanged;

  /// Hosts with a free seat, stable order for a list.
  List<CoopHostInfo> get hosts =>
      _hosts.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  bool get isAdvertising => _broadcast != null;

  /// Advertise this device as a joinable host on [port].
  ///
  /// Bonjour service names must be unique per type on the link; the platform
  /// resolves a clash by suffixing (`Ace (2)`), so two pilots with the same
  /// name both stay visible.
  Future<void> advertise(int port, String pilotName) async {
    await stopAdvertising();
    final broadcast = BonsoirBroadcast(
      service: BonsoirService(
        name: pilotName,
        type: serviceType,
        port: port,
        attributes: {'pilot': pilotName},
      ),
    );
    await broadcast.initialize();
    await broadcast.start();
    _broadcast = broadcast;
  }

  /// Withdraw the advertisement — the seat is taken, or hosting ended.
  Future<void> stopAdvertising() async {
    final broadcast = _broadcast;
    _broadcast = null;
    await broadcast?.stop();
  }

  /// Start looking for hosts. [onHostsChanged] fires as they resolve and drop.
  Future<void> browse() async {
    await stopBrowsing();
    final discovery = BonsoirDiscovery(type: serviceType);
    await discovery.initialize();
    _events = discovery.eventStream!.listen((event) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          // Found only carries the name; addresses arrive on resolve.
          event.service.resolve(discovery.serviceResolver);
        case BonsoirDiscoveryServiceResolvedEvent():
          _put(event.service);
        case BonsoirDiscoveryServiceUpdatedEvent():
          _put(event.service);
        case BonsoirDiscoveryServiceLostEvent():
          if (_hosts.remove(event.service.name) != null) onHostsChanged?.call();
        default:
          break;
      }
    });
    await discovery.start();
    _discovery = discovery;
  }

  Future<void> stopBrowsing() async {
    await _events?.cancel();
    _events = null;
    final discovery = _discovery;
    _discovery = null;
    await discovery?.stop();
    if (_hosts.isNotEmpty) {
      _hosts.clear();
      onHostsChanged?.call();
    }
  }

  void _put(BonsoirService service) {
    // A device that hosts and browses at once would list itself.
    if (service.name == _broadcast?.service.name) return;
    final addresses = service.hostAddresses;
    if (addresses.isEmpty) return;
    // Prefer IPv4: a link-local IPv6 needs a zone id (`%en0`) that the
    // resolver strips, and Socket.connect cannot reach it without one.
    final address = addresses.firstWhere(
      (a) => a.contains('.') && !a.contains(':'),
      orElse: () => addresses.first,
    );
    _hosts[service.name] = CoopHostInfo(
      name: service.attributes['pilot'] ?? service.name,
      address: address,
      port: service.port,
    );
    onHostsChanged?.call();
  }

  Future<void> dispose() async {
    onHostsChanged = null;
    await stopBrowsing();
    await stopAdvertising();
  }
}
