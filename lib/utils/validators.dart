import 'package:lrsofficer/utils/app_regex.dart';

class Validators {
  bool validateNumber(String number) {
    return RegExp(AppRegex.mobileNumberPattern).hasMatch(number);
  }
}
