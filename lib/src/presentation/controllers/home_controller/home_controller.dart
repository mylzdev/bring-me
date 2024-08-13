import 'dart:math' as math;

import 'package:bring_me/src/core/utils/popups/loader.dart';
import 'package:bring_me/src/data/repository/room_repository/room_model.dart';
import 'package:bring_me/src/data/repository/room_repository/room_player_model.dart';
import 'package:bring_me/src/data/repository/room_repository/room_repository.dart';
import 'package:bring_me/src/presentation/controllers/player_controller/player_controller.dart';
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
import '../room_controller/room_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final _playerController = PlayerController.instance;

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

  @override
  void onInit() {
    Get.delete<RoomController>(force: true);
    super.onInit();
  }

  Future<void> createRoom() async {
    try {
      TFullScreenLoader.openLoadingDialog('Creating room');
      roomID.value = THelperFunctions
          .generateRoomID(); // TODO : Fix where can be duplicated

      final room = RoomModel(
          roomID: roomID.value,
          maxPlayers: maxPlayers.value.floor(),
          huntLocation: huntLocation.value,
          gameState: GameState.initial,
          players: [
            RoomPlayerModel(
              name: _playerController.playername,
              avatarIndex: _playerController.playerInfo.value.avatarIndex,
            ),
          ],
          items: []);
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

  Future<void> joinRoomViaCode() async {
    try {
      if (!joinRoomState.currentState!.validate()) return;

      TFullScreenLoader.openLoadingDialog('Joining room');
      final updatedRoom = await RoomRepository.instance.joinRoom(
        joinRoomTextController.text,
        _playerController.playerInfo.value,
      );
      roomInfo.value = updatedRoom;

      Get.offAll(() => const RoomScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> joinRoomViaQR(String qrCodeResult) async {
    try {
      final updatedRoom = await RoomRepository.instance.joinRoom(
        qrCodeResult,
        _playerController.playerInfo.value,
      );
      roomInfo.value = updatedRoom;

      Get.offAll(() => const RoomScreen());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> playSinglePlayer() async {
    try {
      gameState.value = GameState.initial;
      Get.offAll(() => const GameScreen());
      final response =
          await GeminiRepository.instance.loadHunt(huntLocation.value);

      // Randomize items
      final shuffledItems = (response.toList()..shuffle(math.Random()))
          .take(RoomPlayerModel.maxItems)
          .toList();

      items.addAll(shuffledItems);
      gameState.value = GameState.progress;
    } catch (e) {
      Get.to(() => const HomeScreen());
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }
}
