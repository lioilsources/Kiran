import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/services/save_service.dart';
import 'package:tyrian_mobile/systems/campaign.dart';

/// The campaign save must live beside the endless save, never over it. The
/// endless run's `game_state` is what the roguelike loop protects across
/// deaths; a campaign session overwriting it would wipe that run.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const endlessJson =
      '{"saveVersion":2,"pilotName":"Fable","credit":777,"score":42,'
      '"hp":125,"hpMax":125,"shield":100.0,"shieldMax":100.0,"genMax":100.0,'
      '"genPower":4.0,"level":9,"nextWeaponLevel":1,"weapons":[]}';

  setUp(() => SharedPreferences.setMockInitialValues({'game_state': endlessJson}));

  test('saving the campaign leaves the endless save byte-identical', () async {
    final c = CampaignState(currentNode: 3, completed: {0, 1, 2},
        vessel: {'credit': 5, 'pilotName': 'Fable'});
    await SaveService.saveCampaignState(c.toJson());

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('game_state'), endlessJson);
  });

  test('a campaign save round-trips and carries its own version', () async {
    final c = CampaignState(currentNode: 2, completed: {0, 1},
        stars: {0: {'x'}}, vessel: {'credit': 5});
    await SaveService.saveCampaignState(c.toJson());

    final raw = await SaveService.loadCampaignState();
    expect(raw, isNotNull);
    expect(raw!['campaignSaveVersion'], SaveService.campaignSaveVersion);
    final back = CampaignState.fromJson(raw);
    expect(back.currentNode, 2);
    expect(back.completed, {0, 1});
    expect(back.starsFor(0), 1);
    expect(back.vessel['credit'], 5);
  });

  test('no campaign yet reads as null, not as an empty state', () async {
    expect(await SaveService.loadCampaignState(), isNull);
  });

  test('clearing the campaign does not clear the endless run', () async {
    await SaveService.saveCampaignState(CampaignState().toJson());
    await SaveService.clearCampaignState();
    expect(await SaveService.loadCampaignState(), isNull);
    final endless = await SaveService.loadGameState();
    expect(endless, jsonDecode(endlessJson));
  });
}
