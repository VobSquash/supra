import 'package:client_email/client_email.dart';
import 'package:client_models/client_models.dart';
import 'package:test/test.dart';

void main() {
  test('format lists fee rows with pro-rata', () {
    final fees = FeesService.calculateProRataForMonth(
      const [
        FeesItemDTO(cost: 1200, feeType: 'SSA'),
        FeesItemDTO(cost: 6000, feeType: 'Social'),
      ],
      6,
    );
    final body = FeesBodyFormatter.format(fees, asOf: DateTime(2026, 6, 1));
    expect(body, contains('SSA'));
    expect(body, contains('Social'));
    expect(body, contains('\n'));
  });
}
