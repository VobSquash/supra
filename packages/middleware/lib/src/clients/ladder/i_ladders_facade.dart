import 'package:client_models/client_models.dart';

enum LadderDivision { men, ladies, masters }

abstract class ILaddersFacade {
  Future<LaddersListDTO> loadLadders();

  /// Admin/elevated: persist quick order/team/challenge edits for one ladder.
  Future<void> saveLadderDivision({
    required LadderDivision division,
    required List<LadderItemDTO> items,
  });

  /// Admin/elevated: add a member to the selected ladder at [sortOrder].
  Future<void> addMemberToDivision({
    required LadderDivision division,
    required String vobGuid,
    required int sortOrder,
    int? team,
    bool canBeChallenged = false,
  });

  /// Admin/elevated: remove member from selected ladder.
  Future<void> removeMemberFromDivision({
    required LadderDivision division,
    required String vobGuid,
  });
}
