import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> internetCheck() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  } else {
    return false;
  }
}
