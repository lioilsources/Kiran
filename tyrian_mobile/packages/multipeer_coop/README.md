# multipeer_coop

Apple Multipeer Connectivity for Kirian's two-player co-op: nearby discovery
and a reliable, ordered byte channel over peer-to-peer Wi-Fi and Bluetooth,
with no shared network. iOS 13+ and macOS 11+; nothing else, by nature of the
API — Android's Nearby Connections does not talk to it.

The plugin is deliberately thin. One `MCSession` per app; the host advertises
and accepts a single invitation while its seat is free, the joiner browses
and invites, and after that `send()`/`data` events carry whatever bytes the
game hands over. Kirian's framed protocol rides on it unchanged.

Runner requirements (already in both `Info.plist`s):

- `NSBonjourServices` lists `_kirian-coop._tcp` and `_kirian-coop._udp` —
  Multipeer uses both.
- `NSLocalNetworkUsageDescription`, `NSBluetoothAlwaysUsageDescription`.
- macOS sandbox: `com.apple.security.device.bluetooth` in the entitlements.

Sharp edges worth knowing (both from Apple's docs, both hit in practice):

- Keep browsing until the peer reports `connected`; stopping the browser
  earlier drops the pending invitation.
- Discovery info is read once per advertisement — to change it, stop and
  start advertising.
