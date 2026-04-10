import 'package:client_models/client_models.dart';

/// Facade for user/profile read operations exposed by `middlewareSl`.
///
/// This is the stable surface `app_bloc` should depend on.
abstract class IUsersFacade {
  Future<List<BasicProfileDTO>> loadBasicProfiles();
  Future<List<BasicProfileDTO>> loadActiveBasicProfiles();
  Future<BasicProfileDTO?> loadProfileByVobGuid(String vobGuid);
}
