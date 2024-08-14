import '../../config/enums.dart';

extension GameStateExtension on GameState {
  String get name => toString().split('.').last;

  static GameState fromString(String state) {
    return GameState.values.firstWhere(
      (e) => e.name == state,
      orElse: () => GameState.initial,
    );
  }
}
