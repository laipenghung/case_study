import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnection {
  CheckConnection();

  bool isOnline(ConnectivityResult network){
    switch(network){
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }
}