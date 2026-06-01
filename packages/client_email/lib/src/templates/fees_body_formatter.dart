import 'package:client_models/client_models.dart';

/// Formats [FeesDTO] rows for the general mail template body.
abstract final class FeesBodyFormatter {
  FeesBodyFormatter._();

  static String format(FeesDTO fees, {DateTime? asOf}) {
    final date = (asOf ?? DateTime.now()).toDMMMMY();
    final lines = <String>[
      'Current VOB fee requirements ($date):',
      '',
    ];

    for (final item in fees.items) {
      final type = item.feeType.trim();
      if (type.isEmpty) continue;
      final annual = _money(item.cost);
      final pro = item.proRataCost;
      if (pro != null && pro > 0 && type.toUpperCase() != 'SSA') {
        lines.add('$type: R$annual per year (pro-rata balance R${_money(pro)})');
      } else {
        lines.add('$type: R$annual');
      }
    }

    if (lines.length <= 2) {
      lines.add('No fee rows are configured.');
    }

    lines.add('');
    lines.add('Contact the club if you have questions about payment.');

    return lines.join('\n');
  }

  static String _money(double v) {
    if (v == v.roundToDouble()) {
      return v.toStringAsFixed(0);
    }
    return v.toStringAsFixed(2);
  }
}
