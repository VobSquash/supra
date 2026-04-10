import 'package:client_models/client_models.dart';

abstract class ILaddersFacade {
  Future<LaddersListDTO> loadLadders();
}
