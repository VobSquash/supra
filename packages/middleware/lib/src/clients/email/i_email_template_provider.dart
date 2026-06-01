/// Loads bundled HTML templates (implemented in the Flutter app layer).
abstract class IEmailTemplateProvider {
  Future<String> loadGeneralMailHtml();
  Future<String> loadBookingMailHtml();
}
