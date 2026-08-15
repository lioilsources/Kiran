import 'package:flutter/material.dart';
import '../game/tyrian_game.dart';
import 'credits_wave.dart';
import 'enemy_counter.dart';
import '../entities/vessel.dart';
import '../rendering/health_bar.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../services/music_service.dart';
import 'skin_painter.dart';

/// Ported from OSD panel rendering — HUD overlay showing ship stats.
/// Implemented as a Flutter overlay widget (not Flame).
class OsdPanel extends StatelessWidget {
  final TyrianGame game;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onSkinSelect;

  const OsdPanel({super.key, required this.game, this.onMuteToggle, this.onSkinSelect});

  Widget? _statIcon(String key, {double size = 14}) {
    final sprite = AssetLibrary.instance.getIcon(key);
    return sprite == null
        ? null
        : SizedBox(
            width: size,
            height: size,
            child: CustomPaint(painter: SpritePainter(sprite)),
          );
  }

  Widget _staggeredBar(
    double val,
    double max,
    Color color,
    String label,
    String iconKey, {
    double indent = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: SizedBox(
        width: 130,
        child: HealthBar(
          label: label,
          value: val,
          maxValue: max,
          color: color,
          height: 8,
          icon: _statIcon(iconKey),
          segments: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sector = game.currentSector;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(0),
                Colors.black.withAlpha(180),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sector name
              if (sector != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    sector.caption,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),

              // Stats (staggered bars left) + Credits (right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildVesselStats(game.vessel, 'P1'),
                      if (game.isCoop) ...[
                        const SizedBox(height: 6),
                        _buildVesselStats(game.vessel2!, 'P2'),
                      ],
                    ],
                  ),
                  const Spacer(),
                  if (game.state != GameState.paused)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCreditsWidget(),
                        const SizedBox(height: 2),
                        // Enemy tally lives under the credits so it can never
                        // hide behind the HUD — it *is* the HUD.
                        EnemyCounter(game: game),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 4),

              // Bottom row: PAUSED label + buttons
              Row(
                children: [
                  if (game.state == GameState.paused)
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (game.state == GameState.paused && onSkinSelect != null)
                        GestureDetector(
                          onTap: onSkinSelect,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withAlpha(40),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.orangeAccent.withAlpha(100)),
                            ),
                            child: const Text(
                              'SKIN',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          SoundService.instance.toggleMute();
                          onMuteToggle?.call();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            SoundService.instance.muted
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          MusicService.instance.toggleMute();
                          onMuteToggle?.call();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            MusicService.instance.muted
                                ? Icons.music_off
                                : Icons.music_note,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => game.togglePause(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            game.state == GameState.paused ? 'RESUME' : 'PAUSE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVesselStats(Vessel vessel, String playerLabel) {
    final dead = !vessel.visible || vessel.hp <= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (game.isCoop)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              playerLabel,
              style: TextStyle(
                color: dead
                    ? Colors.red
                    : (playerLabel == 'P2'
                        ? const Color(0xFF00FF80)
                        : Colors.cyanAccent),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        _staggeredBar(vessel.hp.toDouble(), vessel.hpMax.toDouble(),
            Colors.redAccent, 'HP', 'icon_life',
            indent: 0),
        const SizedBox(height: 3),
        _staggeredBar(vessel.shield, vessel.shieldMax,
            Colors.cyanAccent, 'SH', 'icon_shield',
            indent: 10),
        const SizedBox(height: 3),
        _staggeredBar(vessel.genValue, vessel.genMax,
            Colors.amberAccent, 'PWR', 'icon_gen',
            indent: 20),
      ],
    );
  }

  static const _creditsStyle = TextStyle(
    color: Colors.greenAccent,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  Widget _buildCreditsWidget() {
    if (!game.isCoop) {
      return CreditsWave(
        prefix: 'Credits: ',
        value: game.vessel.credit,
        style: _creditsStyle,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        CreditsWave(
            prefix: 'P1: ',
            value: game.vessel.credit,
            suffix: 'cr',
            style: _creditsStyle),
        CreditsWave(
            prefix: 'P2: ',
            value: game.vessel2!.credit,
            suffix: 'cr',
            style: _creditsStyle),
      ],
    );
  }
}

/// Top-of-screen boss health bar, visible while a phased boss is on the field.
/// Rebuilt via the same ~4Hz onOsdUpdate tick as the rest of the HUD.
class BossHealthBar extends StatelessWidget {
  final TyrianGame game;

  const BossHealthBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final boss = game.activeBoss;
    if (boss == null) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(180),
                Colors.black.withAlpha(0),
              ],
            ),
          ),
          child: HealthBar(
            label: boss.caption,
            value: boss.hp.toDouble(),
            maxValue: boss.hpMax.toDouble(),
            color: Colors.deepOrangeAccent,
            height: 8,
            segments: 20,
          ),
        ),
      ),
    );
  }
}
