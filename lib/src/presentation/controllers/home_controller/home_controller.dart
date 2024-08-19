import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/common/widgets/button/elevated_button.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/enums.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/text_strings.dart';
import '../../../core/utils/device/permission_handler.dart';
import '../../../core/utils/helpers/helper_functions.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/loader.dart';
import '../../../core/utils/popups/popups.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../../data/repository/room_repository/room_model.dart';
import '../../../data/repository/room_repository/room_player_model.dart';
import '../../../data/repository/room_repository/room_repository.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';
import '../../screens/home/home.dart';
import '../../screens/room/room.dart';
import '../../screens/single_game/single_game_screen.dart';
import '../player_controller/player_controller.dart';
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

  // QR
  final _photoPicker = PhotoPickerService();
  final mobileController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

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
      TFullScreenLoader.stopLoading();
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
          await GeminiRepository.instance.loadItems(huntLocation.value);

      items.addAll(response);
      gameState.value = GameState.progress;
    } catch (e) {
      Get.to(() => const HomeScreen());
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  Future<void> askForCameraPermission({required VoidCallback callback}) async {
    try {
      final isPermissionGranted = await TPermissionHandler.requestPermission(
          permission: Permission.camera);
      if (isPermissionGranted) {
        TLoggerHelper.info('sdaad');
        callback();
      } else {
        Get.defaultDialog(
          titlePadding: EdgeInsets.only(top: TSizes.defaultSpace),
          backgroundColor: TColors.darkContainer,
          title: 'Allow Camera Permission',
          middleText:
              'We need your permission to access camera for QR Scanning and Image Validation',
          contentPadding: EdgeInsets.all(TSizes.defaultSpace),
          confirm: TElevatedButton(
            title: 'Confirm',
            onPressed: () async =>
                await TPermissionHandler.requestPermissionWithSettings()
                    .then((_) => Get.back()),
          ),
        ).then(
          (_) => Get.back(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scanQrFromImage() async {
    try {
      final XFile? image = await _photoPicker.pickImage();

      if (image != null) {
        try {
          TFullScreenLoader.openLoadingDialog('Joining room');

          final File imageFile = File(image.path);
          final result = await mobileController.analyzeImage(imageFile.path);

          if (result != null && result.barcodes.isNotEmpty) {
            final qrCode = result.barcodes.first.rawValue;
            await HomeController.instance.joinRoomViaQR(qrCode!);
          } else {
            TLoggerHelper.warning('No QR Code found in the image.');
            TPopup.warningSnackbar(
                title: TTexts.ohSnap,
                message: 'No QR Code found in the image.');
            TFullScreenLoader.stopLoading();
          }
        } catch (e) {
          TLoggerHelper.error('Error scanning QR code from image: $e');
          TFullScreenLoader.stopLoading();
          TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
        }
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  Future<void> showShareAppDialog() async {
    try {
      final result = await Share.share(
        'Check out this amazing app: BRING ME! A classic game with a modern twist. Get it here: https://github.com/mylzdev/bring-me/releases',
        subject: 'Join the Fun with Bring Me',
      );

      if (result.status == ShareResultStatus.success) {
        TLoggerHelper.info('SUCCESS');
      } else if (result.status == ShareResultStatus.dismissed) {
        TLoggerHelper.warning('DISMISSED');
      } else {
        TLoggerHelper.error('UNAVAILABLE');
      }
    } catch (e) {
      TLoggerHelper.error('Failed to share the app: $e');
    }
  }
}
