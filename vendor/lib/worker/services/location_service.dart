import 'package:geolocator/geolocator.dart';

class LocationService {
  /// 🚀 Optimized location fetch (FAST + SAFE)
  static Future<Position?> getFastLocation() async {
    try {
      // 1️⃣ Check if location service is enabled
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // 2️⃣ Check permission
      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // 3️⃣ FAST PATH (cached location)
      final lastPosition =
      await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        return lastPosition;
      }

      // 4️⃣ Fallback (balanced accuracy)
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      return null;
    }
  }

  /// 🔁 Backward compatibility (optional)
  static Future<Position?> getCurrentLocation() async {
    return getFastLocation();
  }
}
