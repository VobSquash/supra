import 'package:dupra/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:middleware/middleware_clients.dart';

/// Loads Dupra-bundled HTML templates for [IEmailFacade].
class DupraEmailTemplateProvider implements IEmailTemplateProvider {
  @override
  Future<String> loadGeneralMailHtml() => rootBundle.loadString(Assets.html.generalMail);

  @override
  Future<String> loadBookingMailHtml() => rootBundle.loadString(Assets.html.bookingMail);
}
