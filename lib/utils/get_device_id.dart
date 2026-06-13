import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';

class GetDeviceId {
  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }

/*   Future<String?> getIpAddress() async {
    // Attempt to get local IP address
    Future<String?> getLocalIp() async {
      final networkList = await NetworkInterface.list();
      if (networkList.isNotEmpty) {
        for (var interface in networkList) {
          for (var addr in interface.addresses) {
            if (!kReleaseMode) debugPrint(
                'IP::::: ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
            // Check if it's an IPv4 address and not a loopback address
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              return addr.address;
            }
          }
        }
      }
      return null; // Return null if no IP found
    }

    // First attempt to get local IP
    String? ip = await getLocalIp();

    // Retry if the first attempt failed
    if (ip == null) {
      if (!kReleaseMode) debugPrint('Retrying to get local IP...');
      ip = await getLocalIp();
    }

    // If still null, fall back to getting public IP
    if (ip == null) {
      if (!kReleaseMode) debugPrint('Retrying to get local IP...');
      ip = await getLocalIp();
      if (!kReleaseMode) debugPrint('Failed to get local IP. Fetching public IP instead...');
      var ipAddress = IpAddress(type: RequestType.text);
      dynamic publicIp = await ipAddress.getIp();
      if (!kReleaseMode) debugPrint("Public IP: ${publicIp.toString()}");
      return publicIp.toString();
    }

    return ip; // Return the local IP if found
  } */

  Future<String?> getIpAddress() async {
    // Attempt to get local IP address
    Future<String?> getLocalIp() async {
      final networkList = await NetworkInterface.list();
      if (networkList.isNotEmpty) {
        for (var interface in networkList) {
          for (var addr in interface.addresses) {
            if (!kReleaseMode) {
              debugPrint(
                  'IP::::: ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
            }
            // Check if it's an IPv4 address and not a loopback address
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              return addr.address;
            }
          }
        }
      }
      return null; // Return null if no IP found
    }

    int attempts = 0;
    String? ip;

    // Loop until we get the local IP or reach a certain limit
    while (ip == null && attempts < 4) {
      attempts += 1;
      if (!kReleaseMode) debugPrint('Attempt $attempts to get local IP...');
      ip = await getLocalIp();
      await Future.delayed(Duration(milliseconds: 500)); // Wait before retrying
    }

    // If still null, fall back to getting public IP
    if (ip == null) {
      if (!kReleaseMode) {
        debugPrint(
            'Failed to get local IP after $attempts attempts. Fetching public IP instead...');
      }
      var ipAddress = IpAddress(type: RequestType.text);
      dynamic publicIp = await ipAddress.getIp();
      if (!kReleaseMode) debugPrint("Public IP: ${publicIp.toString()}");
      return publicIp.toString();
    }

    if (!kReleaseMode) {
      debugPrint(
          'Successfully obtained local IP after $attempts attempts: $ip');
    }
    return ip; // Return the local IP if found
  }
}
