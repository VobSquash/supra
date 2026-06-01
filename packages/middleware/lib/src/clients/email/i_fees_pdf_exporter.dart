import 'package:client_models/client_models.dart';

/// Generates a membership fees PDF on disk (Flutter app implementation).
abstract class IFeesPdfExporter {
  Future<String> exportFeesToPdf({
    required FeesDTO data,
    String? fileName,
  });
}
