import 'package:client_models/client_models.dart';

/// Replaces `##F…##` tokens in bundled HTML templates.
abstract final class TemplateRenderer {
  TemplateRenderer._();

  static String apply(String template, Map<String, String> variables) {
    var result = template;
    for (final entry in variables.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result.replaceAll('ï»¿', '');
  }

  static String generalBodyHtml(String rawBody) {
    return rawBody.replaceAll('/n', '<br />').replaceAll('\n', '<br />');
  }

  static String formatGeneralMail({
    required String template,
    required String title,
    required String body,
    DateTime? now,
  }) {
    final date = (now ?? DateTime.now()).toDMMMMY();
    return apply(template, {
      '##FDate##': date,
      '##FTitle##': title,
      '##FBody##': generalBodyHtml(body),
    });
  }

  static String formatBookingMail({
    required String template,
    required String displayName,
    required DateTime bookingDate,
    required int courtNo,
    DateTime? now,
  }) {
    final date = (now ?? DateTime.now()).toDMMMMY();
    return apply(template, {
      '##FDate##': date,
      '##FName##': displayName,
      '##FBody##': 'Your booking was successful.',
      '##FBookingDate##': bookingDate.toDMMMMY(),
      '##FTimeslot##': bookingDate.toHMM(),
      '##FCourtNo##': courtNo.toString(),
    });
  }
}
