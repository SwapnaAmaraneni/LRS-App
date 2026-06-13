import 'package:geocoding/geocoding.dart';
import 'package:lrsofficer/data/logger_resuable.dart';

class GetCurrentAddress {
  Future<String> getCurrentAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      return '';
    }

    Placemark bestPlacemark = placemarks[0];
    int maxDetails = 0;

    for (Placemark place in placemarks) {
      int details = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
        place.postalCode,
      ].where((element) => element != null && element.isNotEmpty).length;

      if (details > maxDetails) {
        bestPlacemark = place;
        maxDetails = details;
      }
    }

    // Construct the complete address dynamically
    List<String> addressComponents = [];

    if (bestPlacemark.street != null && bestPlacemark.street!.isNotEmpty) {
      addressComponents.add(bestPlacemark.street!);
    }
    if (bestPlacemark.subLocality != null &&
        bestPlacemark.subLocality!.isNotEmpty) {
      addressComponents.add(bestPlacemark.subLocality!);
    }
    if (bestPlacemark.locality != null && bestPlacemark.locality!.isNotEmpty) {
      addressComponents.add(bestPlacemark.locality!);
    }
    if (bestPlacemark.administrativeArea != null &&
        bestPlacemark.administrativeArea!.isNotEmpty) {
      addressComponents.add(bestPlacemark.administrativeArea!);
    }
    if (bestPlacemark.postalCode != null &&
        bestPlacemark.postalCode!.isNotEmpty) {
      addressComponents.add(bestPlacemark.postalCode!);
    }
    if (bestPlacemark.country != null && bestPlacemark.country!.isNotEmpty) {
      addressComponents.add(bestPlacemark.country!);
    }

    // Join components with a comma
    final currentAddress = addressComponents.join(', ');

    AppLogger().logDebug("currentAddress:::::$currentAddress");
    return currentAddress;
  }
}
