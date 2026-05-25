import 'package:client_models/client_models.dart';
import 'package:test/test.dart';

void main() {
  test('calculateProRataForMonth matches legacy FeesService math', () {
    final items = [
      const FeesItemDTO(cost: 50, proRataCost: null, feeType: 'SSA'),
      const FeesItemDTO(cost: 1200, proRataCost: null, feeType: 'League'),
    ];

    final month = 6;
    final dto = FeesService.calculateProRataForMonth(items, month);
    expect(dto.items[0].proRataCost, isNull);
    expect(dto.items[1].proRataCost, 1050);
  });
}
