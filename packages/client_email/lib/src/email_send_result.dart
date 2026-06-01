import 'package:meta/meta.dart';

@immutable
class EmailSendResult {
  const EmailSendResult({
    required this.sentCount,
    required this.failedRecipients,
  });

  final int sentCount;
  final List<String> failedRecipients;

  bool get hasFailures => failedRecipients.isNotEmpty;
}
