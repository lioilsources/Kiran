import Foundation
import MultipeerConnectivity
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#endif

/// One MCSession per app, two roles: the host advertises and accepts a single
/// invitation while its seat is free; the joiner browses, invites, and then
/// the session carries framed game messages both ways in `.reliable` mode,
/// which keeps order — so the Dart side reuses its TCP framing untouched.
///
/// Peers are handed to Dart as opaque ids ("<displayName>#<hash>"): MCPeerID
/// is not serialisable, and two pilots may share a display name.
public class MultipeerCoopPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  /// Bonjour service type; must be listed in NSBonjourServices as both
  /// `_kirian-coop._tcp` and `_kirian-coop._udp` (MC uses both).
  static let serviceType = "kirian-coop"

  private var sink: FlutterEventSink?
  private var myPeer: MCPeerID?
  private var session: MCSession?
  private var advertiser: MCNearbyServiceAdvertiser?
  private var browser: MCNearbyServiceBrowser?
  private var peers: [String: MCPeerID] = [:]
  private var accepting = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    let instance = MultipeerCoopPlugin()
    let methods = FlutterMethodChannel(name: "multipeer_coop/methods", binaryMessenger: messenger)
    registrar.addMethodCallDelegate(instance, channel: methods)
    let events = FlutterEventChannel(name: "multipeer_coop/events", binaryMessenger: messenger)
    events.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "startAdvertising":
      let name = args["name"] as? String ?? "Pilot"
      let info = args["info"] as? [String: String]
      ensureSession(name: name)
      accepting = true
      advertiser?.stopAdvertisingPeer()
      let adv = MCNearbyServiceAdvertiser(peer: myPeer!, discoveryInfo: info, serviceType: Self.serviceType)
      adv.delegate = self
      adv.startAdvertisingPeer()
      advertiser = adv
      result(nil)

    case "stopAdvertising":
      accepting = false
      advertiser?.stopAdvertisingPeer()
      advertiser = nil
      result(nil)

    case "startBrowsing":
      let name = args["name"] as? String ?? "Pilot"
      ensureSession(name: name)
      browser?.stopBrowsingForPeers()
      let br = MCNearbyServiceBrowser(peer: myPeer!, serviceType: Self.serviceType)
      br.delegate = self
      br.startBrowsingForPeers()
      browser = br
      result(nil)

    case "stopBrowsing":
      // The peer map survives: an invitation sent just before may still land.
      browser?.stopBrowsingForPeers()
      browser = nil
      result(nil)

    case "invite":
      guard let id = args["peerId"] as? String, let peer = peers[id],
            let browser = browser, let session = session else {
        result(FlutterError(code: "no_peer", message: "unknown peer, or not browsing", details: nil))
        return
      }
      browser.invitePeer(peer, to: session, withContext: nil, timeout: 15)
      result(nil)

    case "send":
      guard let id = args["peerId"] as? String, let peer = peers[id], let session = session,
            let data = args["data"] as? FlutterStandardTypedData else {
        result(FlutterError(code: "no_peer", message: "unknown peer or no session", details: nil))
        return
      }
      do {
        try session.send(data.data, toPeers: [peer], with: .reliable)
        result(nil)
      } catch {
        result(FlutterError(code: "send_failed", message: error.localizedDescription, details: nil))
      }

    case "disconnect":
      teardown()
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func ensureSession(name: String) {
    if session != nil { return }
    let peer = MCPeerID(displayName: String(name.prefix(63)))
    myPeer = peer
    let s = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .required)
    s.delegate = self
    session = s
  }

  private func teardown() {
    accepting = false
    advertiser?.stopAdvertisingPeer()
    advertiser = nil
    browser?.stopBrowsingForPeers()
    browser = nil
    session?.disconnect()
    session = nil
    myPeer = nil
    peers.removeAll()
  }

  private func id(for peer: MCPeerID) -> String {
    let key = "\(peer.displayName)#\(peer.hash)"
    peers[key] = peer
    return key
  }

  /// Delegate callbacks arrive on private queues; the event sink is main-thread only.
  private func emit(_ event: [String: Any]) {
    DispatchQueue.main.async { self.sink?(event) }
  }

  // MARK: FlutterStreamHandler

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    sink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    return nil
  }
}

extension MultipeerCoopPlugin: MCNearbyServiceAdvertiserDelegate {
  public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                         withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    // One seat: accept only while advertising and nobody is connected.
    let free = accepting && (session?.connectedPeers.isEmpty ?? false)
    _ = id(for: peerID)
    invitationHandler(free, free ? session : nil)
  }

  public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    emit(["type": "error", "message": "advertise: \(error.localizedDescription)"])
  }
}

extension MultipeerCoopPlugin: MCNearbyServiceBrowserDelegate {
  public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
    emit(["type": "found", "id": id(for: peerID), "name": peerID.displayName, "info": info ?? [:]])
  }

  public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    emit(["type": "lost", "id": id(for: peerID)])
  }

  public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    emit(["type": "error", "message": "browse: \(error.localizedDescription)"])
  }
}

extension MultipeerCoopPlugin: MCSessionDelegate {
  public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    let name: String
    switch state {
    case .connected: name = "connected"
    case .connecting: name = "connecting"
    default: name = "disconnected"
    }
    emit(["type": "state", "id": id(for: peerID), "name": peerID.displayName, "state": name])
  }

  public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    emit(["type": "data", "id": id(for: peerID), "data": FlutterStandardTypedData(bytes: data)])
  }

  public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
  public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
