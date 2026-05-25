import 'package:meta/meta.dart';

import 'fees.dart';

/// Sync port of legacy `FeesService` — SSA row + `monthlyProRataMultiplier` + `ceil`.
@immutable
abstract final class FeesService {
  FeesService._();

  static const Map<int, int> monthlyProRataMultiplier = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 1,
    6: 2,
    7: 3,
    8: 4,
    9: 5,
    10: 6,
    11: 7,
    12: 8,
  };

  static FeesDTO calculateProRata(List<FeesItemDTO> items) {
    final currentMonth = DateTime.now().month;
    return calculateProRataForMonth(items, currentMonth);
  }

  static FeesDTO calculateProRataForMonth(List<FeesItemDTO> items, int month) {
    final ssaFee = items.firstWhere((element) => element.feeType == 'SSA');
    final multiplier = monthlyProRataMultiplier[month] ?? 0;

    final updatedItems = items.map((item) {
      if (item.feeType == 'SSA') {
        return item;
      }

      final monthlyRate = item.cost / 12.0;
      final remainingMonths = 12 - multiplier;
      final proRataAmount = (monthlyRate * remainingMonths + ssaFee.cost).ceil().toDouble();

      return item.copyWith(proRataCost: proRataAmount);
    }).toList();

    return FeesDTO(items: updatedItems);
  }
}
