# Vendored: just_audio_media_kit 2.1.0

Copied verbatim from pub.dev (`just_audio_media_kit-2.1.0`, Unlicense / public
domain) with one behavioural change, applied in two places in
`lib/mediakit_player.dart`:

    - if (_player.state.duration.inSeconds > 0)
    + if (_player.state.duration > Duration.zero)

Upstream gates every `seek()` on the media's duration being at least one whole
second; for a shorter clip the seek is silently dropped and parked in
`_setPosition`, which is only ever applied on a `duration` event that also
passes the same whole-second test — i.e. never. Six of our ten SFX are 0.49 s
long, so on the libmpv backend (iOS < 18.4, Linux, Windows) a pool player
could not be rewound once it had played to the end: it played exactly once
and was dead for the rest of the session. `SoundService` documents the other
half of that bug (the `play()` no-op after completion).

Nothing else differs from upstream. To bump: replace this directory with the
new release, re-apply the two-line change, update the version here.
