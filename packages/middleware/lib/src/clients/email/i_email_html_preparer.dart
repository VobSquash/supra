/// Rewrites template HTML so images render in mail clients (inline or public URLs).
abstract class IEmailHtmlPreparer {
  Future<String> prepareHtml(String html);
}
