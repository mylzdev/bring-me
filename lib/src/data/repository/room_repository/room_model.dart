import 'package:bring_me/src/core/utils/extensions/game_state_extension.dart';
import 'package:bring_me/src/core/utils/extensions/hunt_location_extension.dart';
import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/config/enums.dart';

class RoomModel {
  String roomID;
  int maxPlayers;
  HuntLocation huntLocation;
  List<PlayerModel> players;
  GameState gameState;

  RoomModel({
    required this.roomID,
    required this.maxPlayers,
    required this.huntLocation,
    required this.players,
    required this.gameState,
  });

  static RoomModel empty() => RoomModel(
        roomID: '12345',
        maxPlayers: 2,
        huntLocation: HuntLocation.indoor,
        players: [],
        gameState: GameState.initial,
      );

  // Factory method for creating a RoomModel from a JSON object
  factory RoomModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return RoomModel(
        roomID: data['roomID'] as String,
        maxPlayers: data['maxPlayers'] as int,
        huntLocation: HuntLocationExtension.fromString(data['huntLocation']),
        players: (data['players'] as List)
            .map((playerData) => PlayerModel.fromMap(playerData))
            .toList(),
        gameState: GameStateExtension.fromString(data['gameState']),
      );
    } else {
      return RoomModel.empty();
    }
  }

  // Method for converting a RoomModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'maxPlayers': maxPlayers,
      'huntLocation': huntLocation.name,
      'players': players.map((e) => e.toMap()).toList(),
      'gameState': gameState.name,
    };
  }

  // Method for getting a map with players only
  Map<String, dynamic> toPlayerJson() {
    return {
      'players': players.map((e) => e.toMap()).toList(),
    };
  }

  RoomModel copyWith({
    String? roomID,
    int? maxPlayers,
    HuntLocation? huntLocation,
    List<PlayerModel>? players,
    bool? isAllReady,
    GameState? gameState,
  }) {
    return RoomModel(
      roomID: roomID ?? this.roomID,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      huntLocation: huntLocation ?? this.huntLocation,
      players: players ?? this.players,
      gameState: gameState ?? this.gameState,
    );
  }
}
