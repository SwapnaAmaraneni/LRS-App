
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GetCurrentVersion {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
   
  AppLogger().logDebug("cversion :${packageInfo.version}");
      
    return packageInfo.version;
  }
}
