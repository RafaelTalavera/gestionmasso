import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/remote/internet_checker.dart';

import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnetivityRepository {

  ConnectivityRepositoryImpl(this._connectivity, this._internetChecker);
  final Connectivity _connectivity;
  final InternetChecker _internetChecker;

  @override
  Future<bool> get hasInternet async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }
    return _internetChecker.hasInternet();
  }
}
