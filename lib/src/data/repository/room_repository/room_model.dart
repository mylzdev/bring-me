import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/config/enums.dart';
import '../../../core/utils/extensions/game_state_extension.dart';
import '../../../core/utils/extensions/hunt_location_extension.dart';
import 'room_player_model.dart';

class RoomModel {
  String roomID;
  int maxPlayers;
  HuntLocation huntLocation;
  List<RoomPlayerModel> players;
  GameState gameState;
  List<String> items;

  RoomModel({
    required this.roomID,
    required this.maxPlayers,
    required this.huntLocation,
    required this.players,
    required this.gameState,
    required this.items,
  });

  static RoomModel empty() => RoomModel(
        roomID: '12345',
        maxPlayers: 2,
        huntLocation: HuntLocation.indoor,
        players: [],
        gameState: GameState.initial,
        items: ['']
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
            .map((playerData) => RoomPlayerModel.fromMap(playerData))
            .toList(),
        gameState: GameStateExtension.fromString(data['gameState']),
        items: List<String>.from(data['items'] as List),
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
      'items': items,
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
    List<RoomPlayerModel>? players,
    bool? isAllReady,
    GameState? gameState,
    List<String>? items,
  }) {
    return RoomModel(
      roomID: roomID ?? this.roomID,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      huntLocation: huntLocation ?? this.huntLocation,
      players: players ?? this.players,
      gameState: gameState ?? this.gameState,
      items: items ?? this.items,
    );
  }
}
