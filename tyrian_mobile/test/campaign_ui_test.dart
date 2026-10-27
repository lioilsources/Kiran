import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/campaign_tracker.dart';
import 'package:tyrian_mobile/ui/campaign_map.dart';
import 'package:tyrian_mobile/ui/campaign_result.dart';

/// The campaign's two screens, pumped at phone size. The app itself cannot be
/// launched on this machine (macOS release signing), so this is where a
/// painter that throws or a panel that overflows gets caught.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  /// A game that never loaded: the campaign screens read only `campaign`,
  /// which is what keeps them testable without assets or a running loop.
  TyrianGame gameAt(CampaignState state) => TyrianGame()..campaign = state;

  group('route map', () {
    testWidgets('paints a fresh campaign with only the first node open',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(CampaignMapScreen(
        game: gameAt(CampaignState()),
        onLaunch: (_) {},
        onBack: () {},
      )));

      expect(tester.takeException(), isNull);
      expect(find.text('CAMPAIGN'), findsOneWidget);
      expect(find.text('0/20   ★ 0'), findsOneWidget);
      // The briefing shows the first node and offers to fly it.
      expect(find.text('1. ${kCampaignNodes.first.caption}'), findsOneWidget);
      expect(find.text('LAUNCH'), findsOneWidget);
    });

    testWidgets('a locked node says so instead of offering a launch',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(CampaignMapScreen(
        game: gameAt(CampaignState()),
        onLaunch: (_) {},
        onBack: () {},
      )));

      // Walk forward past the frontier.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('LOCKED'), findsOneWidget);
      expect(find.textContaining('Clear the node before it'), findsOneWidget);
    });

    testWidgets('confirming on an open node launches exactly that one',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      int? launched;
      final state = CampaignState()
        ..markCompleted(0)
        ..markCompleted(1);
      await tester.pumpWidget(host(CampaignMapScreen(
        game: gameAt(state),
        onLaunch: (i) => launched = i,
        onBack: () {},
      )));

      // Focus opens on the frontier — node 3 of the route.
      expect(find.text('3. ${kCampaignNodes[2].caption}'), findsOneWidget);
      await tester.tap(find.text('LAUNCH'));
      expect(launched, 2);
    });

    testWidgets('a mid-campaign route paints without overflowing',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final state = CampaignState();
      for (var i = 0; i < 12; i++) {
        state.markCompleted(i, starsEarned: {'untouched'});
      }
      await tester.pumpWidget(host(CampaignMapScreen(
        game: gameAt(state),
        onLaunch: (_) {},
        onBack: () {},
      )));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('12/20   ★ 12'), findsOneWidget);
    });
  });

  Hostile deadFalcon() => Hostile(
        caption: 'x',
        id: 0,
        hostType: HostType.falcon1,
        hp: 0,
        hpMax: 100,
      );

  Vessel pilot() => Vessel()
    ..hpMax = 100
    ..hp = 100;

  group('result card', () {
    NodeResult resultFor(CampaignNode node, {required bool cleared}) {
      final t = CampaignTracker()..beginNode(node.index);
      if (cleared) {
        for (var i = 0; i < 200; i++) {
          t.onKill(deadFalcon());
        }
      }
      return t.evaluate(
          node: node, vessel: pilot(), hullDamage: !cleared, elapsed: 55);
    }

    testWidgets('a cleared node offers the way on', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(CampaignResultCard(
        node: kCampaignNodes.first,
        result: resultFor(kCampaignNodes.first, cleared: true),
        creditsEarned: 7940,
        onContinue: () {},
        onRetry: () {},
      )));

      expect(tester.takeException(), isNull);
      expect(find.text('NODE CLEARED'), findsOneWidget);
      expect(find.text('CONTINUE'), findsOneWidget);
      expect(find.text('+7 940 cr'), findsOneWidget);
    });

    testWidgets('a failed node only offers a retry', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(CampaignResultCard(
        node: kCampaignNodes.first,
        result: resultFor(kCampaignNodes.first, cleared: false),
        creditsEarned: 120,
        onContinue: () {},
        onRetry: () {},
      )));

      expect(tester.takeException(), isNull);
      expect(find.text('NODE FAILED'), findsOneWidget);
      expect(find.text('CONTINUE'), findsNothing);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('an unlock is announced with what it opened', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final boss = kCampaignNodes.firstWhere((n) => n.bossOrdinal == 1);
      await tester.pumpWidget(host(CampaignResultCard(
        node: boss,
        result: resultFor(boss, cleared: true),
        creditsEarned: 28960,
        unlocked: 'Vulcan Cannon · Small Vulcan',
        onContinue: () {},
        onRetry: () {},
      )));

      expect(tester.takeException(), isNull);
      expect(find.text('WEAPON TIER UNLOCKED'), findsOneWidget);
      expect(find.text('Vulcan Cannon · Small Vulcan'), findsOneWidget);
    });
  });
}
