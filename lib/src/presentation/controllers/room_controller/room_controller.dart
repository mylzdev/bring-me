import 'dart:async';
import 'dart:math' as math;

import 'package:bring_me/src/core/config/colors.dart';
import 'package:bring_me/src/core/config/enums.dart';
import 'package:bring_me/src/core/config/sizes.dart';
import 'package:bring_me/src/core/config/text_strings.dart';
import 'package:bring_me/src/core/utils/logging/logger.dart';
import 'package:bring_me/src/core/utils/popups/loader.dart';
import 'package:bring_me/src/core/utils/popups/popups.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:bring_me/src/data/repository/room_repository/room_model.dart';
import 'package:bring_me/src/data/repository/room_repository/room_repository.dart';
import 'package:bring_me/src/presentation/controllers/home_controller/home_controller.dart';
import 'package:bring_me/src/presentation/screens/home/home.dart';
import 'package:bring_me/src/presentation/screens/multi_game/multi_game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers/helper_functions.dart';
import '../../../data/repository/gemini_repository/gemini_client.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../../data/repository/player_repository/player_model.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';

class RoomController extends GetxController with WidgetsBindingObserver {
  static RoomController get instance => Get.find();

  RoomController(this.homeController, this.shouldGenerateFakeItems);
  final HomeController homeController;
  final bool shouldGenerateFakeItems;

  // Services
  final _photoPickerService = PhotoPickerService();
  final _stopwatch = Stopwatch();
  Timer? timer;
  final timeLeft = 180.obs; // 3 minutes

  // Repositories
  final _roomRepository = RoomRepository.instance;
  final _playerName = PlayerRepository.instance.username.value;

  // Items
  final _items = RxList<String>();
  final itemLeft = 5.obs; // Hard coded must change player model item left
  Rx<ItemHuntStatus> itemHuntStatus = ItemHuntStatus.initial.obs;
  final itemRandomizer =
      THelperFunctions.generateRandomInt(GeminiClient.maxGeneratedItems).obs;
  final RxList<int> calledItems = <int>[].obs;

  String get fakeItem => _items[itemLeft.value];
  String get legitItem => _items[itemRandomizer.value];
  String get currentitem => shouldGenerateFakeItems ? fakeItem : legitItem;

  // Multiplayer Config
  Rx<RoomModel> roomInfo = RoomModel.empty().obs;
  String get roomID => roomInfo.value.roomID;
  List<PlayerModel> get sortedPlayer => roomInfo.value.players.toList()
    ..sort(
      (a, b) => b.score.compareTo(a.score),
    );

  // Player
  final score = 0.obs;
  final isReady = false.obs;
  bool get isRoomLeader {
    final currentPlayer = roomInfo.value.players.firstWhere(
      (player) => player.name == _playerName,
    );
    return currentPlayer.isLeader;
  }

  // Stream
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomSubscription;

  // Local game state && UI
  final isImagePickerShown = false.obs;
  final waitingForOthersOpacity = 1.0.obs;
  bool _gameStarted = false;
  RxBool isFinish = false.obs;
  bool get hideFooterButtons {
    if (itemHuntStatus.value != ItemHuntStatus.initial || isFinish.value || roomInfo.value.gameState == GameState.ended) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    roomInfo.value =
        homeController.roomInfo.value; // Initialize room info value
    _startRoomCheck();
    super.onInit();
  }

  @override
  void onClose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _roomSubscription?.cancel();
    _stopwatch.stop();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        quitRoom();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  // Starts checking the room status and updates the UI accordingly
  void _startRoomCheck() {
    _roomSubscription =
        _roomRepository.roomStream(roomID).listen((roomSnapshot) {
      if (!roomSnapshot.exists) {
        _handleRoomClosure();
      } else {
        // Game Starts here
        _updateRoomInfo(roomSnapshot);
      }
    }, onError: (error) {
      TLoggerHelper.info('$error');
    });
  }

  // Handle room closure
  void _handleRoomClosure() {
    _roomSubscription?.cancel();
    Get.offAll(() => const HomeScreen());
    Get.delete<RoomController>(force: true);
    if (!isRoomLeader) {
      TPopup.warningSnackbar(
          title: TTexts.ohSnap, message: 'The room owner left the room');
    }
  }

  // Update room info and start game if necessary
  void _updateRoomInfo(DocumentSnapshot<Map<String, dynamic>> roomSnapshot) {
    roomInfo.value = RoomModel.fromSnapshot(roomSnapshot);
    if (roomInfo.value.gameState == GameState.progress && !_gameStarted) {
      _gameStarted = true;
      _startGame();
    }
  }

  // Starts the game
  void _startGame() {
    TFullScreenLoader.stopLoading();
    Get.offAll(() => const MultiGameScreen());
    TPopup.customToast(message: 'Game Started');

    _generateUniqueItemRandomizer();
    calledItems.add(itemRandomizer.value);
    _stopwatch.start();
    _startGameTimer();
    Timer.periodic(1.seconds, (_){
      waitingForOthersOpacity.value = waitingForOthersOpacity.value == 1.0 ? 0.0 : 1.0;
    });

    everAll(
      [score, itemLeft],
      (_) => _updatePlayerScoreAndItemLeft(),
    );
  }

  Future<void> _updatePlayerScoreAndItemLeft() async {
    try {
      await _roomRepository.updatePlayerScoreAndItemLeft(
        roomID,
        _playerName,
        score.value,
        itemLeft.value,
      );
      TLoggerHelper.info('Score: ${score.value}, Item left: ${itemLeft.value}');
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  // Starts game timer && Game Ends
  void _startGameTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      timeLeft.value--;
      if (timeLeft.value == 0) {
        if (isImagePickerShown.value) {
          TLoggerHelper.info('message');
        }
        timer!.cancel();
        await endGame();
      }
    });
  }

  Future<void> quitRoom() async {
    try {
      if (isRoomLeader) {
        await _roomRepository.deleteRoom(roomID);
      } else {
        Get.offAll(() => const HomeScreen());
        Get.delete<RoomController>(force: true);
        await _roomRepository.removePlayerFromRoom(roomID, _playerName);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> setReady() async {
    try {
      await _roomRepository.updatePlayerReadyState(
        roomID,
        _playerName,
        isReady.value = !isReady.value,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> startGame() async {
    try {
      if (!shouldGenerateFakeItems) {
        final isAllReady = await _roomRepository.checkIfAllPlayersReady(roomID);
        if (isAllReady) {
          TFullScreenLoader.openLoadingDialog('Generating Items');
          final response = await GeminiRepository.instance.loadHunt(
            roomInfo.value.huntLocation,
          );
          _items.addAll(response);
          await _roomRepository.updateGameState(roomID, GameState.progress);
        } else {
          TPopup.customToast(message: 'Player(s) are not ready');
        }
      } else {
        TFullScreenLoader.openLoadingDialog('Generating Items');
        _items.addAll(
            ['Remote', 'Cabinet', 'Lamp', 'Lighter', 'Coffe Cup', 'Outlet']);
        await _roomRepository.updateGameState(roomID, GameState.progress);
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      _handleError(e);
    }
  }

  Future<void> endGame() async {
    try {
      await _roomRepository.updateGameState(roomID, GameState.ended);
      await Future.delayed(1.seconds);
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  void onLeaveRoom() async {
    await Get.defaultDialog(
      title:
          isRoomLeader ? 'The room will be dismissed' : 'Confirm leaving room',
      middleText: 'Are you sure you want to leave the room?',
      contentPadding: EdgeInsets.all(TSizes.defaultSpace),
      titlePadding: EdgeInsets.only(top: TSizes.defaultSpace),
      confirm: ElevatedButton(
        onPressed: () async => await quitRoom(),
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.error,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: const Text('Leave'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  // Game Progress methods ---------------------------------------------------------------------------------

  Future<void> validateImage() async {
    try {
      isImagePickerShown.value = true;
      final photo = await _photoPickerService.pickPhoto();
      itemHuntStatus.value = ItemHuntStatus.validationInProgress;
      final isPhotoValid =
          await GeminiRepository.instance.validateImage(currentitem, photo);
      if (isPhotoValid) {
        _handleSuccessfulImageValidation();
        _resetTimer();
      } else {
        _handleFailedImageValidation();
      }
    } catch (e) {
      _handleImageValidationError(e);
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      itemHuntStatus.value = ItemHuntStatus.initial;
      isImagePickerShown.value = false;
    }
  }

  // Handles successful image validation
  void _handleSuccessfulImageValidation() async {
    incrementScore();
    itemHuntStatus.value = ItemHuntStatus.validationSuccess;
    skipItem();
    _resetTimer();
  }

  // Handles failed image validation
  void _handleFailedImageValidation() {
    itemHuntStatus.value = ItemHuntStatus.validationFailure;
    TLoggerHelper.info('Failed');
  }

  // Handles image validation error
  void _handleImageValidationError(Object e) {
    TLoggerHelper.error(e.toString());
    itemHuntStatus.value = ItemHuntStatus.validationFailure;
    TLoggerHelper.info('Failed');
  }

  _resetTimer() {
    _stopwatch.reset();
    Future.delayed(1.seconds);
    _stopwatch.start();
  }

  void skipItem() async {
    try {
      if (itemLeft.value >= 2) {
        itemLeft.value--;
        _generateUniqueItemRandomizer();
        calledItems.add(itemRandomizer.value);
        _resetTimer();
      } else {
        itemLeft.value--;
        isFinish.value = true;
        // Local End game
      }
    } catch (e) {
      rethrow;
    }
  }

  void incrementScore() {
    final scorePenalty = _stopwatch.elapsedMilliseconds ~/ 3000 * 1;
    score.value += 100 - math.min<int>(scorePenalty, 50);
  }

  void _generateUniqueItemRandomizer() {
    int newItem;
    do {
      newItem =
          THelperFunctions.generateRandomInt(GeminiClient.maxGeneratedItems);
    } while (calledItems.contains(newItem));
    itemRandomizer.value = newItem;
  }

  // Handle generic errors
  void _handleError(Object e) {
    TLoggerHelper.error(e.toString());
    TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
  }
}
