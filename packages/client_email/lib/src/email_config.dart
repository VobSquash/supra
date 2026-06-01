import 'package:meta/meta.dart';

/// SMTP settings for club transactional mail (Brevo / Sendinblue relay, etc.).
@immutable
class EmailConfig {
  const EmailConfig({
    required this.smtpHost,
    required this.smtpUsername,
    required this.smtpPassword,
    required this.fromEmail,
    this.fromName = 'Vob Squash Mailer',
    this.useSsl = false,
    this.bookingCcEmails = const ['vobsquashsa@gmail.com'],
    this.welcomeCcEmails = const [
      'vobsquashsa@gmail.com',
      'grahampauljeffery@gmail.com',
    ],
    this.challengeCcEmails = const [
      'vobsquashsa@gmail.com',
      'grahampauljeffery@gmail.com',
    ],
  });

  final String smtpHost;
  final String smtpUsername;
  final String smtpPassword;
  final String fromEmail;
  final String fromName;
  final bool useSsl;
  final List<String> bookingCcEmails;
  final List<String> welcomeCcEmails;
  final List<String> challengeCcEmails;

  bool get isConfigured {
    return smtpHost.trim().isNotEmpty &&
        smtpUsername.trim().isNotEmpty &&
        smtpPassword.trim().isNotEmpty &&
        fromEmail.trim().isNotEmpty;
  }

  /// Builds config from optional [AppConfig] email fields; returns null when incomplete.
  static EmailConfig? fromAppJson(Map<String, dynamic> json) {
    final host = (json['smtp_host'] as String?)?.trim() ?? '';
    final user = (json['smtp_username'] as String?)?.trim() ?? '';
    final pass = (json['smtp_password'] as String?)?.trim() ?? '';
    final from = (json['smtp_from_email'] as String?)?.trim() ?? '';
    if (host.isEmpty || user.isEmpty || pass.isEmpty || from.isEmpty) {
      return null;
    }
    final ccBooking = _parseEmailList(json['smtp_booking_cc']);
    final ccWelcome = _parseEmailList(json['smtp_welcome_cc']);
    final ccChallenge = _parseEmailList(json['smtp_challenge_cc']);
    return EmailConfig(
      smtpHost: host,
      smtpUsername: user,
      smtpPassword: pass,
      fromEmail: from,
      fromName: (json['smtp_from_name'] as String?)?.trim().isNotEmpty == true
          ? (json['smtp_from_name'] as String).trim()
          : 'Vob Squash Mailer',
      useSsl: json['smtp_use_ssl'] == true,
      bookingCcEmails: ccBooking.isEmpty
          ? const ['vobsquashsa@gmail.com']
          : ccBooking,
      welcomeCcEmails: ccWelcome.isEmpty
          ? const [
              'vobsquashsa@gmail.com',
              'grahampauljeffery@gmail.com',
            ]
          : ccWelcome,
      challengeCcEmails: ccChallenge.isEmpty
          ? const [
              'vobsquashsa@gmail.com',
              'grahampauljeffery@gmail.com',
            ]
          : ccChallenge,
    );
  }

  static List<String> _parseEmailList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }
}
