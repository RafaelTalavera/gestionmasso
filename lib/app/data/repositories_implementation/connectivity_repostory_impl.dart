import 'package:gestionmasso/app/domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnetivityRepository {
  @override
  Future<bool> get hasInternet {
    return Future.value(true);
  }
}
