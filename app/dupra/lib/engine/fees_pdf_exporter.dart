import 'dart:io';
import 'dart:ui';

import 'package:client_models/client_models.dart';
import 'package:dupra/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:middleware/middleware.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Membership descriptions keyed by [FeesItemDTO.feeType].
Map<String, String> _membershipDescriptions(int seasonYear) => {
      'League': 'Eligible to play league for $seasonYear Season',
      'LeagueAndMasters':
          'Eligible to play mens and Masters for $seasonYear Season',
      'MastersOnly': 'Eligible to play Masters for $seasonYear Season',
      'LeagueStudent':
          'Under 25 members eligible to play league for $seasonYear Season',
      'LeagueScholar':
          'Under 25 members eligible to play league for $seasonYear Season',
      'Social': 'Not eligible for league participation',
      'SocialStudent': 'Not eligible for league participation',
      'SocialScholar': 'Not eligible for league participation',
    };

const double _titleFontSize = 24;
const double _subtitleFontSize = 14;
const double _sectionTitleFontSize = 12;
const double _bodyFontSize = 12;
const double _infoFontSize = 10;

final PdfFont _titleFont = PdfStandardFont(
  PdfFontFamily.helvetica,
  _titleFontSize,
  style: PdfFontStyle.bold,
);
final PdfFont _subtitleFont = PdfStandardFont(
  PdfFontFamily.helvetica,
  _subtitleFontSize,
  style: PdfFontStyle.italic,
);
final PdfFont _sectionTitleFont = PdfStandardFont(
  PdfFontFamily.helvetica,
  _sectionTitleFontSize,
  style: PdfFontStyle.bold,
);
final PdfFont _bodyFont = PdfStandardFont(PdfFontFamily.helvetica, _bodyFontSize);
final PdfFont _bodyBoldFont = PdfStandardFont(
  PdfFontFamily.helvetica,
  _bodyFontSize,
  style: PdfFontStyle.bold,
);
final PdfFont _bodyUnderlineFont = PdfStandardFont(
  PdfFontFamily.helvetica,
  _bodyFontSize,
  style: PdfFontStyle.underline,
);
final PdfFont _infoFont = PdfStandardFont(PdfFontFamily.helvetica, _infoFontSize);

Future<double> _drawVobHeader({
  required PdfPage page,
  required String title,
  required String subtitle,
  required Uint8List headerImageBytes,
}) async {
  final headerImage = PdfBitmap(headerImageBytes);

  page.graphics.drawRectangle(
    brush: PdfSolidBrush(PdfColor(230, 230, 250)),
    bounds: Rect.fromLTWH(0, 0, page.size.width, 90),
  );

  page.graphics.drawImage(
    headerImage,
    const Rect.fromLTWH(20, 10, 150, 70),
  );

  page.graphics.drawString(
    title,
    _titleFont,
    bounds: const Rect.fromLTWH(190, 20, 410, 32),
  );

  page.graphics.drawString(
    subtitle,
    _subtitleFont,
    bounds: const Rect.fromLTWH(190, 54, 410, 20),
  );

  page.graphics.drawString(
    'Sent Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
    PdfStandardFont(PdfFontFamily.helvetica, 10),
    bounds: Rect.fromLTWH(page.size.width - 250, 76, 130, 14),
  );

  return 90;
}

bool _isMembershipFeeRow(FeesItemDTO i) =>
    i.feeType != 'SSA' && i.feeType != 'MastersAdditional';

/// Exports fee data to a PDF file and returns the absolute path.
class DupraFeesPdfExporter implements IFeesPdfExporter {
  @override
  Future<String> exportFeesToPdf({
    required FeesDTO data,
    String? fileName,
  }) async {
    final seasonYear = DateTime.now().year;
    final descriptions = _membershipDescriptions(seasonYear);

    final document = PdfDocument();
    final page = document.pages.add();

    final headerImageData = await rootBundle.load(Assets.images.homeLightMode.path);
    var y = await _drawVobHeader(
      page: page,
      title: 'Membership Options',
      subtitle: 'VOB Squash Club | $seasonYear Season',
      headerImageBytes: headerImageData.buffer.asUint8List(),
    );

    final iconData = await rootBundle.load(Assets.icons.player.path);
    final playerIcon = PdfBitmap(iconData.buffer.asUint8List());

    const iconSize = 36.0;
    const rowSpacing = 16.0;
    const iconLeft = 10.0;
    const textLeft = 60.0;
    const feeRight = 350.0;

    final ssa = data.items.firstWhere(
      (item) => item.feeType == 'SSA',
      orElse: () => FeesItemDTO.empty(),
    );

    for (final item in data.items.where(_isMembershipFeeRow)) {
      page.graphics.drawImage(
        playerIcon,
        Rect.fromLTWH(iconLeft, y, iconSize, iconSize),
      );
      page.graphics.drawString(
        item.feeType.capitalizeAndSplit(),
        _bodyBoldFont,
        bounds: Rect.fromLTWH(textLeft, y, 140, 20),
      );
      final desc = descriptions[item.feeType] ?? '';
      if (desc.isNotEmpty) {
        page.graphics.drawString(
          desc,
          _bodyFont,
          bounds: Rect.fromLTWH(textLeft, y + 18, 280, 16),
        );
      }
      page.graphics.drawString(
        'R ${item.proRataCost?.toStringAsFixed(2) ?? 'N/A'}',
        _bodyUnderlineFont,
        bounds: Rect.fromLTWH(feeRight, y, 100, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
      y += iconSize + rowSpacing;
    }

    y += 4;
    page.graphics.drawLine(
      PdfPen(PdfColor(180, 180, 180), width: 2),
      Offset(0, y),
      Offset(500, y),
    );
    y += 12;

    page.graphics.drawString(
      'Extra Information',
      _sectionTitleFont,
      bounds: Rect.fromLTWH(0, y, 500, 20),
    );
    y += 18;
    final info = [
      '• All fees are calculated on a full-month prorata basis. The current month is included as a payable full month.',
      '• VOB pays the mandatory SSA fee (R ${ssa.cost.toStringAsFixed(2)}) on your behalf to Squash South Africa.',
      '• It is not included as part of the prorata calculation. Once Squash SA issues us with your SSA Number for $seasonYear,',
      ' it will be added to your VOB profile.',
    ];
    for (final line in info) {
      page.graphics.drawString(
        line,
        _infoFont,
        bounds: Rect.fromLTWH(0, y, 500, 20),
      );
      y += 14;
    }

    y += 12;
    page.graphics.drawString(
      'Banking Details',
      _sectionTitleFont,
      bounds: Rect.fromLTWH(0, y, 500, 20),
    );
    y += 18;
    const banking = [
      'Payment method: EFT',
      'Bank: Standard Bank',
      'Account Name: Vob Squash Club',
      'Account Number: 270-027-742',
      'Branch Code: 025-608',
    ];
    for (final line in banking) {
      page.graphics.drawString(
        line,
        _infoFont,
        bounds: Rect.fromLTWH(0, y, 500, 20),
      );
      y += 14;
    }

    final bytes = await document.save();
    document.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${fileName ?? 'membership_options'}.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return path;
  }
}
