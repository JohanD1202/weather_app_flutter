import 'package:flutter_riverpod/legacy.dart';

final unitProvider = StateNotifierProvider<UnitNotifier, bool>((ref) => UnitNotifier());

class UnitNotifier extends StateNotifier<bool> {
  UnitNotifier() : super(false);

  void toggle() => state = !state;
}
