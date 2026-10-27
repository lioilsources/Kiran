/// Console diagnostics for the audio stack.
///
/// Every audio failure in this app used to be swallowed — three separate
/// `catch (_) {}` sites — so an iPad that went completely silent (iOS below
/// 18.4 has no Ogg demuxer; see `main.dart`) left nothing behind to work
/// from. These lines are the only way to tell, from a build already on a
/// device, which backend is live and which assets it refused.
///
/// Every line carries the `[audio]` prefix: attach the device and filter the
/// Console.app stream on that string to get the whole picture.
library;

/// Detail lines are capped. A backend that fails every single call must not
/// turn the log into its own denial of service — the first few failures say
/// everything the later thousand would. Summary lines are not capped; there
/// are only a handful of them per run.
const int _detailCap = 40;
int _details = 0;

void audioLog(String message) => print('[audio] $message');

/// Log one asset-level failure with the real exception behind it.
void audioLogFailure(String stage, String subject, Object error) {
  if (_details >= _detailCap) return;
  _details++;
  audioLog('$stage failed — $subject — ${error.runtimeType}: $error');
  if (_details == _detailCap) {
    audioLog('further failure detail suppressed (cap $_detailCap)');
  }
}
