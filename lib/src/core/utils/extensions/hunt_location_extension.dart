import '../../config/enums.dart';

extension HuntLocationExtension on HuntLocation {
  String get name => toString().split('.').last;

  static HuntLocation fromString(String location) {
    return HuntLocation.values.firstWhere(
      (e) => e.name == location,
      orElse: () => HuntLocation.indoor,
    );
  }
}
