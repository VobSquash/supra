import 'package:client_models/client_models.dart';
import 'package:middleware/src/mappers/ladder/ladder_challenge_targets_applier.dart';
import 'package:test/test.dart';

LadderItemDTO _player(String guid, int order) =>
    LadderItemDTO.empty().copyWith(vobGuid: guid, order: order, profile: BasicProfileDTO.empty().copyWith(vobGuid: guid));

void main() {
  test('applyViewerChallengeTargets clears flags when viewer guid missing', () {
    final items = [
      _player('a', 1),
      _player('b', 2).copyWith(canBeChallenged: true),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: null);
    expect(out.every((e) => e.canBeChallenged == false), isTrue);
  });

  test('applyViewerChallengeTargets flags the two orders immediately above viewer', () {
    final items = [
      _player('top', 1),
      _player('second', 2),
      _player('third', 3),
      _player('me', 4),
      _player('below', 5),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: 'me');
    bool flagged(String g) => out.firstWhere((e) => e.vobGuid == g).canBeChallenged == true;

    expect(flagged('top'), isFalse);
    expect(flagged('second'), isTrue);
    expect(flagged('third'), isTrue);
    expect(flagged('me'), isFalse);
    expect(flagged('below'), isFalse);
  });

  test('applyViewerChallengeTargets handles rank #2 viewer with only one above', () {
    final items = [
      _player('top', 1),
      _player('me', 2),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: 'me');
    expect(out.firstWhere((e) => e.vobGuid == 'top').canBeChallenged, isTrue);
    expect(out.firstWhere((e) => e.vobGuid == 'me').canBeChallenged, isFalse);
  });

  test('applyViewerChallengeTargets clears targets when viewer is #1', () {
    final items = [
      _player('me', 1),
      _player('below', 2),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: 'me');
    expect(out.every((e) => e.canBeChallenged == false), isTrue);
  });

  test('applyViewerChallengeTargets resolves viewer via profile vobGuid when entry guid empty', () {
    final meProfile = BasicProfileDTO.empty().copyWith(vobGuid: 'me');
    final items = [
      _player('above', 1),
      LadderItemDTO.empty().copyWith(vobGuid: '', order: 2, profile: meProfile),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: 'ME ');
    expect(out.firstWhere((e) => e.vobGuid == 'above').canBeChallenged, isTrue);
    expect(out.firstWhere((e) => e.order == 2).canBeChallenged, isFalse);
  });

  test('applyViewerChallengeTargets matches mixed entry/profile viewer row', () {
    final meProfile = BasicProfileDTO.empty().copyWith(firstName: 'Me', lastName: '', vobGuid: 'viewer-guid');
    final items = [
      _player('p1', 1),
      _player('p2', 2),
      LadderItemDTO.empty().copyWith(vobGuid: '', order: 3, profile: meProfile),
    ];
    final out = applyViewerChallengeTargets(items: items, viewerVobGuid: 'viewer-guid');
    expect(out.where((e) => e.canBeChallenged == true).map((e) => e.vobGuid), containsAll(['p1', 'p2']));
  });
}
