import 'package:client_email/client_email.dart';
import 'package:test/test.dart';

void main() {
  test('formatGeneralMail replaces placeholders', () {
    const template = '##FTitle## — ##FBody## on ##FDate##';
    final html = TemplateRenderer.formatGeneralMail(
      template: template,
      title: 'Hello',
      body: 'Line one/nLine two',
      now: DateTime(2026, 6, 1),
    );
    expect(html, contains('Hello'));
    expect(html, contains('Line one<br />Line two'));
    expect(html, contains('1 June 2026'));
  });
}
