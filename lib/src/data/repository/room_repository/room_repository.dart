import 'package:bring_me/src/core/config/enums.dart';
import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:bring_me/src/data/repository/room_repository/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/exceptions/firebase_exceptions.dart';
import '../../../core/utils/exceptions/format_exceptions.dart';
import '../../../core/utils/exceptions/platform_exceptions.dart';

class RoomRepository extends GetxService {
  static RoomRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createRoom(RoomModel room) async {
    try {
      await _db.collection("Rooms").doc(room.roomID).set(room.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while creating room: $e';
    }
  }

  Future<RoomModel> joinRoom(String roomID, String playerUsername) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      if (room.players.length + 1 > room.maxPlayers) {
        throw 'Room is full';
      }

      room.players.add(
        PlayerModel(
          name: playerUsername,
          isLeader: false,
          isReady: false,
        ),
      );

      // Update the room with the new players list
      await roomRef.update(room.toPlayerJson());

      // Fetch the updated room data
      final updatedRoomSnapshot = await roomRef.get();
      return RoomModel.fromSnapshot(updatedRoomSnapshot);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while joining room: $e';
    }
  }

  Future<void> deleteRoom(String roomID) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      roomRef.delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while quiting room: $e';
    }
  }

  Future<void> removePlayerFromRoom(String roomID, String currentPlayer) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      room.players.removeWhere((player) => player.name == currentPlayer);
      await roomRef.update(room.toPlayerJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while removing player from room: $e';
    }
  }

  Future<void> updatePlayerReadyState(
      String roomID, String username, bool isReady) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      final playerIndex =
          room.players.indexWhere((player) => player.name == username);
      if (playerIndex == -1) {
        throw "Player not found in room";
      }

      room.players[playerIndex] =
          room.players[playerIndex].copyWith(isReady: isReady);
      await roomRef.update(room.toPlayerJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while updating player ready state: $e';
    }
  }

  Future<void> updatePlayerScore(
      String roomID, String username, int newScore) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      final playerIndex =
          room.players.indexWhere((player) => player.name == username);
      if (playerIndex == -1) {
        throw "Player not found in room";
      }

      room.players[playerIndex] =
          room.players[playerIndex].copyWith(score: newScore);
      await roomRef.update(room.toPlayerJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while updating player score: $e';
    }
  }

  Future<bool> checkIfAllPlayersReady(String roomID) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      for (var player in room.players) {
        if (!player.isReady) {
          return false;
        }
      }

      return true;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while checking if all players are ready: $e';
    }
  }

  Future<void> updateGameState(String roomID, GameState gameState) async {
    try {
      final roomRef = _db.collection('Rooms').doc(roomID);
      final roomSnapshot = await roomRef.get();

      if (!roomSnapshot.exists) {
        throw "Room doesn't exist";
      }

      RoomModel room = RoomModel.fromSnapshot(roomSnapshot);

      for (var player in room.players) {
        if (!player.isReady) {
          throw "Player(s) not ready";
        }
      }

      room.gameState = gameState;
      roomRef.update(room.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while checking if all players are ready: $e';
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(String roomID) {
    try {
      return _db.collection('Rooms').doc(roomID).snapshots();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while listening to room: $e';
    }
  }
}
