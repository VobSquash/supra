import 'dart:io';

import 'package:client_email/src/email_config.dart';
import 'package:client_models/client_models.dart';
import 'package:mailer/mailer.dart';

import 'template_renderer.dart';

const _organizerEmail = 'administrator@vobsquash.co.za';

/// Builds booking confirmation [Message] payloads (HTML + calendar attachment).
abstract final class BookingConfirmationBuilder {
  BookingConfirmationBuilder._();

  static Message buildMessage({
    required EmailConfig config,
    required CreateBookingDto booking,
    required String displayName,
    required String recipientEmail,
    required String bookingTemplateHtml,
  }) {
    final bookingDate = booking.bookingDate;
    final courtNo = booking.courtNo;
    final html = TemplateRenderer.formatBookingMail(
      template: bookingTemplateHtml,
      displayName: displayName,
      bookingDate: bookingDate,
      courtNo: courtNo,
    );

    final message = Message()
      ..from = Address(config.fromEmail, config.fromName)
      ..recipients.add(recipientEmail)
      ..subject = 'Vob Booking Successful'
      ..html = html;

    for (final cc in config.bookingCcEmails) {
      message.ccRecipients.add(Address(cc));
    }

    message.attachments.add(
      FileAttachment(
        _generateICalendarFile(
          displayName: displayName,
          email: recipientEmail,
          bookingTimeSlot: bookingDate,
          courtNo: courtNo,
        ),
        contentType: 'text/calendar',
        fileName: 'Squash Game.ics',
      ),
    );

    return message;
  }

  static File _generateICalendarFile({
    required String displayName,
    required String email,
    required DateTime bookingTimeSlot,
    required int courtNo,
  }) {
    final content = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('PRODID:-//Squash Booking')
      ..writeln('VERSION:2.0')
      ..writeln('METHOD:PUBLISH')
      ..writeln('BEGIN:VTIMEZONE')
      ..writeln('TZID:Africa/Johannesburg')
      ..writeln('X-LIC-LOCATION:Africa/Johannesburg')
      ..writeln('BEGIN:STANDARD')
      ..writeln('TZOFFSETFROM:+0200')
      ..writeln('TZOFFSETTO:+0200')
      ..writeln('TZNAME:SAST')
      ..writeln('DTSTART:19700101T000000')
      ..writeln('END:STANDARD')
      ..writeln('END:VTIMEZONE')
      ..writeln('BEGIN:VEVENT')
      ..writeln(
        'DTSTART;TZID=Africa/Johannesburg:${_formatDateTime(bookingTimeSlot)}',
      )
      ..writeln(
        'DTEND;TZID=Africa/Johannesburg:${_formatDateTime(bookingTimeSlot.add(const Duration(minutes: 45)))}',
      )
      ..writeln('DTSTAMP:${_formatDateTime(DateTime.now())}')
      ..writeln('LOCATION:Vob Squash Club - Court $courtNo')
      ..writeln('UID:${DateTime.now().millisecondsSinceEpoch}')
      ..writeln('DESCRIPTION:Squash game')
      ..writeln('X-ALT-DESC;FMTTYPE=text/html:Squash Game')
      ..writeln('SUMMARY:Vob Squash Booking')
      ..writeln('ORGANIZER:MAILTO:$_organizerEmail')
      ..writeln('ATTENDEE;CN="$displayName";RSVP=TRUE:mailto:$email')
      ..writeln('BEGIN:VALARM')
      ..writeln('TRIGGER:-PT45M')
      ..writeln('ACTION:DISPLAY')
      ..writeln('DESCRIPTION:Reminder')
      ..writeln('END:VALARM')
      ..writeln('END:VEVENT')
      ..writeln('END:VCALENDAR');

    final file = File('${Directory.systemTemp.path}/squash_game_${DateTime.now().millisecondsSinceEpoch}.ics');
    file.writeAsStringSync(content.toString());
    return file;
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}T'
        '${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}${dt.second.toString().padLeft(2, '0')}';
  }
}
