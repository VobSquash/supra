import 'package:client_email/client_email.dart';
import 'package:test/test.dart';

void main() {
  test('inlineKnownUrls replaces src with data URI', () {
    const url = 'https://example.com/logo.png';
    const html = '<img src="$url" width="10">';
    final result = EmailHtmlImageInliner.inlineKnownUrls(
      html: html,
      imageBySourceUrl: {
        url: EmailInlineImage(bytes: [0x89, 0x50, 0x4E, 0x47], mimeType: 'image/png'),
      },
    );
    expect(result, contains('data:image/png;base64,'));
    expect(result, isNot(contains(url)));
  });

  test('rewriteMappedUrls rewrites known legacy URLs', () {
    const html =
        '<img src="https://api.vobsquash.co.za/images/stripio/logo-side.png">';
    final result = EmailHtmlImageInliner.rewriteMappedUrls(
      html: html,
      baseUrl: 'https://cdn.example.com/assets/',
      sourceUrlToFilename: {
        'https://api.vobsquash.co.za/images/stripio/logo-side.png': 'logo-side.png',
      },
    );
    expect(result, contains('https://cdn.example.com/assets/logo-side.png'));
  });

  test('rewriteToPublicAssetBase skips URLs already on bucket base', () {
    const base =
        'https://project.supabase.co/storage/v1/object/public/email-images/';
    const html =
        '<img src="https://project.supabase.co/storage/v1/object/public/email-images/logo-side.png">';
    final result = EmailHtmlImageInliner.rewriteToPublicAssetBase(
      html: html,
      baseUrl: base,
    );
    expect(result, html);
  });

  test('bucketImageUrlsInHtml finds bucket URLs', () {
    const base =
        'https://project.supabase.co/storage/v1/object/public/email-images/';
    const html =
        '<img src="https://project.supabase.co/storage/v1/object/public/email-images/facebook-circle-gray.png">';
    final urls = EmailHtmlImageInliner.bucketImageUrlsInHtml(
      html: html,
      bucketBaseUrl: base,
    );
    expect(urls.length, 1);
    expect(urls.first, endsWith('facebook-circle-gray.png'));
  });

  test('rewriteToPublicAssetBase rewrites remote filenames', () {
    const html =
        '<img src="https://api.vobsquash.co.za/images/stripio/logo-side.png">';
    final result = EmailHtmlImageInliner.rewriteToPublicAssetBase(
      html: html,
      baseUrl: 'https://project.supabase.co/storage/v1/object/public/email-images/',
    );
    expect(
      result,
      contains(
        'https://project.supabase.co/storage/v1/object/public/email-images/logo-side.png',
      ),
    );
  });
}
