import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:multipeer_coop/multipeer_coop.dart';

import 'channel.dart';

/// A co-op host a joiner can pick. Either a LAN host (address + port, found
/// over Bonjour) or a nearby Apple device (Multipeer peer id, no network in
/// common needed).
class CoopHostInfo {
  /// The pilot name the host advertises under.
  final String name;

  /// LAN only. IPv4 when the platform offers one; otherwise what resolved.
  final String address;
  final int port;

  /// Multipeer only: the peer to invite. Null for a LAN host.
  final String? peerId;

  const CoopHostInfo({
    required this.name,
    this.address = '',
    this.port = 0,
    this.peerId,
  });

  bool get isNearby => peerId != null;
}

/// Finds and announces co-op hosts over the two paths the game supports.
///
/// **Bonjour** (DNS-SD over mDNS) for players on the same Wi-Fi. This used
/// to be a raw UDP beacon, which since iOS 14 needs Apple's multicast
/// entitlement the app never had — `sendto()` failed and the beacon never
/// left the device, so the join screen fell back to asking for an IP.
/// Bonjour goes through the system resolver and needs only
/// `NSBonjourServices` + `NSLocalNetworkUsageDescription`.
///
/// **Multipeer Connectivity** for iPhone, iPad and Mac with no shared
/// network at all: peer-to-peer Wi-Fi and Bluetooth, AirDrop-style. Apple
/// only; [MultipeerCoop.isSupported] gates it and everything else keeps
/// working without it.
///
/// A host is listed only while it has a free seat: both announcements are
/// withdrawn when a client connects and re-advertised when it leaves.
class CoopDiscovery {
  /// Must match the `NSBonjourServices` entry in `ios/Runner/Info.plist` and
  /// `macos/Runner/Info.plist`, or the system silently refuses to browse.
  static const serviceType = '_tyriancoop._tcp';

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _bonjourEvents;
  StreamSubscription<MultipeerEvent>? _nearbyEvents;
  bool _nearbyBrowsing = false;
  bool _nearbyAdvertising = false;

  /// Resolved hosts keyed by service name / peer id.
  final Map<String, CoopHostInfo> _hosts = {};

  /// Called whenever [hosts] changes.
  void Function()? onHostsChanged;

  /// Hosts with a free seat, stable order for a list.
  List<CoopHostInfo> get hosts =>
      _hosts.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  bool get isAdvertising => _broadcast != null || _nearbyAdvertising;

  MultipeerCoop get _mc => MultipeerCoop.instance;

  /// Advertise this device as a joinable host: on the LAN on [port], and to
  /// nearby Apple devices where Multipeer exists. Bonjour service names must
  /// be unique per type on the link; the platform suffixes a clash
  /// (`Ace (2)`), so two pilots with the same name both stay visible.
  Future<void> advertise(int port, String pilotName) async {
    await stopAdvertising();
    if (MultipeerCoop.isSupported) {
      try {
        await _mc.startAdvertising(pilotName, {'pilot': pilotName});
        _nearbyAdvertising = true;
      } catch (e) {
        print('Discovery: nearby advertise failed: $e');
      }
    }
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

  /// Withdraw both announcements — the seat is taken, or hosting ended.
  Future<void> stopAdvertising() async {
    final broadcast = _broadcast;
    _broadcast = null;
    await broadcast?.stop();
    if (_nearbyAdvertising) {
      _nearbyAdvertising = false;
      try {
        await _mc.stopAdvertising();
      } catch (_) {}
    }
  }

  /// Start looking for hosts on both paths. [onHostsChanged] fires as they
  /// resolve and drop. [pilotName] is what nearby hosts see asking.
  Future<void> browse(String pilotName) async {
    await stopBrowsing();
    if (MultipeerCoop.isSupported) {
      try {
        _nearbyEvents = _mc.events.listen((e) {
          switch (e) {
            case MultipeerPeerFound(:final peer):
              _hosts['mc:${peer.id}'] = CoopHostInfo(
                name: peer.info['pilot'] ?? peer.name,
                peerId: peer.id,
              );
              onHostsChanged?.call();
            case MultipeerPeerLost(:final id):
              if (_hosts.remove('mc:$id') != null) onHostsChanged?.call();
            case MultipeerError(:final message):
              print('Discovery: nearby: $message');
            default:
              break;
          }
        });
        await _mc.startBrowsing(pilotName);
        _nearbyBrowsing = true;
      } catch (e) {
        print('Discovery: nearby browse failed: $e');
      }
    }
    final discovery = BonsoirDiscovery(type: serviceType);
    await discovery.initialize();
    _bonjourEvents = discovery.eventStream!.listen((event) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          // Found only carries the name; addresses arrive on resolve.
          event.service.resolve(discovery.serviceResolver);
        case BonsoirDiscoveryServiceResolvedEvent():
          _putLan(event.service);
        case BonsoirDiscoveryServiceUpdatedEvent():
          _putLan(event.service);
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
    await _bonjourEvents?.cancel();
    _bonjourEvents = null;
    final discovery = _discovery;
    _discovery = null;
    await discovery?.stop();
    await _stopNearbyBrowsing();
    if (_hosts.isNotEmpty) {
      _hosts.clear();
      onHostsChanged?.call();
    }
  }

  Future<void> _stopNearbyBrowsing() async {
    await _nearbyEvents?.cancel();
    _nearbyEvents = null;
    if (_nearbyBrowsing) {
      _nearbyBrowsing = false;
      try {
        await _mc.stopBrowsing();
      } catch (_) {}
    }
  }

  /// Invite a nearby host and wait for the session to come up. Browsing
  /// stays on until then — Multipeer drops an invitation whose browser is
  /// gone. Null when the host declined (seat taken), vanished, or the
  /// [timeout] passed.
  Future<MultipeerChannel?> connectNearby(String peerId,
      {Duration timeout = const Duration(seconds: 20)}) async {
    if (!_nearbyBrowsing) return null;
    final completer = Completer<MultipeerChannel?>();
    late final StreamSubscription<MultipeerEvent> sub;
    sub = _mc.events.listen((e) {
      if (e is! MultipeerPeerStateChanged || e.id != peerId) return;
      if (e.state == MultipeerPeerState.connected && !completer.isCompleted) {
        completer.complete(MultipeerChannel(_mc, peerId, e.name));
      } else if (e.state == MultipeerPeerState.disconnected &&
          !completer.isCompleted) {
        completer.complete(null);
      }
    });
    try {
      await _mc.invite(peerId);
      return await completer.future.timeout(timeout, onTimeout: () => null);
    } catch (e) {
      print('Discovery: invite failed: $e');
      return null;
    } finally {
      await sub.cancel();
      await _stopNearbyBrowsing();
    }
  }

  void _putLan(BonsoirService service) {
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
