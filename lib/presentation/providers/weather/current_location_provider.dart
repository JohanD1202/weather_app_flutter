// current_location_provider.dart
import 'package:flutter_riverpod/legacy.dart';

final currentLocationProvider = StateProvider<Map<String, double>?>((ref) {
  return null; // Al inicio no hay coords
});
