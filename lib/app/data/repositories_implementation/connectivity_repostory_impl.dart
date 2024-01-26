import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gestionmasso/app/data/services/remote/internet_checker.dart';

import 'package:gestionmasso/app/domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnetivityRepository {
  final Connectivity _connectivity;
  final InternetChecker _internetChecker;

  ConnectivityRepositoryImpl(this._connectivity, this._internetChecker);

  @override
  Future<bool> get hasInternet async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }
    return _internetChecker.hasInternet();
  }
}
