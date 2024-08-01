import 'package:bring_me/src/core/utils/popups/loader.dart';
import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:bring_me/src/data/repository/room_repository/room_model.dart';
import 'package:bring_me/src/data/repository/room_repository/room_repository.dart';
import 'package:bring_me/src/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/enums.dart';
import '../../../core/config/text_strings.dart';
import '../../../core/utils/helpers/helper_functions.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/popups.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../screens/room/room.dart';
import '../../screens/single_game/single_game_screen.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final username = PlayerRepository.instance.username.value;

  final isSinglePlayer = true.obs;
  final roomID = '12345'.obs;
  final maxPlayers = 2.0.obs;
  final items = RxList<String>();

  Rx<RoomModel> roomInfo = RoomModel.empty().obs;

  final joinRoomTextController = TextEditingController();
  GlobalKey<FormState> joinRoomState = GlobalKey<FormState>();

  Rx<HuntLocation> huntLocation = HuntLocation.indoor.obs;
  Rx<GameState> gameState = GameState.initial.obs;

  void setMaxUser(double value) => maxPlayers.value = value;
  void setHuntLocation(HuntLocation location) => huntLocation.value = location;

  Future<void> createRoom() async {
    try {
      TFullScreenLoader.openLoadingDialog('Creating room');
      roomID.value = THelperFunctions.generateRoomID();

      final room = RoomModel(
        roomID: roomID.value,
        maxPlayers: maxPlayers.value.floor(),
        huntLocation: huntLocation.value,
        gameState: GameState.initial,
        players: [PlayerModel(name: username)],
      );
      await RoomRepository.instance.createRoom(room);

      roomInfo.value = room;
      Get.offAll(() => const RoomScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => TFullScreenLoader.stopLoading);
    }
  }

  Future<void> joinRoom() async {
    try {
      if (!joinRoomState.currentState!.validate()) return;

      TFullScreenLoader.openLoadingDialog('Joining room');
      final updatedRoom = await RoomRepository.instance
          .joinRoom(joinRoomTextController.text, username);
      roomInfo.value = updatedRoom;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => TFullScreenLoader.stopLoading);
      Get.offAll(() => const RoomScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> playSinglePlayer() async {
    try {
      gameState.value = GameState.initial;
      Get.offAll(() => const GameScreen());
      final response =
          await GeminiRepository.instance.loadHunt(huntLocation.value);
      gameState.value = GameState.progress;
      items.addAll(response);
    } catch (e) {
      Get.to(() => const HomeScreen());
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }
}
