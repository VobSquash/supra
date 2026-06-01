import 'package:client_email/client_email.dart';
import 'package:dupra/engine/dupra_email_image_manifest.dart';
import 'package:middleware/middleware.dart';

/// Rewrites template image `src` values to `{emailAssetBaseUrl}{filename}`.
class DupraEmailHtmlPreparer implements IEmailHtmlPreparer {
  @override
  Future<String> prepareHtml(String html) async {
    final baseUrl = middlewareSl<ClientConfigs>().emailAssetBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError(
        'Email images are not configured. Set email_asset_base_url in app_config.json '
        'or ensure supabase_url is set (bucket: email-images).',
      );
    }

    final mapped = EmailHtmlImageInliner.rewriteMappedUrls(
      html: html,
      baseUrl: baseUrl,
      sourceUrlToFilename: DupraEmailImageManifest.sourceUrlToFilename,
    );
    return EmailHtmlImageInliner.rewriteToPublicAssetBase(
      html: mapped,
      baseUrl: baseUrl,
    );
  }
}
