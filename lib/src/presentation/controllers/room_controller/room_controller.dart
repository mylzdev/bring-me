import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/dialog/custom_dialog.dart';
import '../../../core/config/enums.dart';
import '../../../core/config/text_strings.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/loader.dart';
import '../../../core/utils/popups/popups.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../../data/repository/room_repository/room_model.dart';
import '../../../data/repository/room_repository/room_player_model.dart';
import '../../../data/repository/room_repository/room_repository.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';
import '../../screens/home/home.dart';
import '../../screens/multi_game/multi_game.dart';
import '../home_controller/home_controller.dart';
import '../player_controller/player_controller.dart';

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
  String get playerName => PlayerController.instance.playername;

  // Items
  final _items = RxList<String>();
  final _fakeItems = RxList<String>();
  final itemLeft = RoomPlayerModel
      .maxItems.obs; // Hard coded must change player model item left
  Rx<ItemHuntStatus> itemHuntStatus = ItemHuntStatus.initial.obs;

  String get fakeItem => _fakeItems[itemLeft.value];
  String get legitItem => _items[itemLeft.value - 1];
  String get currentitem => shouldGenerateFakeItems ? fakeItem : legitItem;

  // Multiplayer Config
  Rx<RoomModel> roomInfo = RoomModel.empty().obs;
  String get roomID => roomInfo.value.roomID;
  bool get isDraw {
    final highestScore = sortedPlayer.first;

    if (sortedPlayer.length == 1) {
      return false;
    }

    return roomInfo.value.players
        .every((player) => player.score == highestScore.score);
  }

  List<RoomPlayerModel> get sortedPlayer => roomInfo.value.players.toList()
    ..sort(
      (a, b) => b.score.compareTo(a.score),
    );

  // Player
  final score = 0.obs;
  final isReady = false.obs;
  bool get isRoomLeader {
    final currentPlayer = roomInfo.value.players.firstWhere(
      (player) => player.name == playerName,
    );
    return currentPlayer.isLeader;
  }

  // Stream
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomSubscription;

  // Local game state && UI
  final isPlayReadyTapped = false.obs;
  void onPlayReadyTapped() =>
      isPlayReadyTapped.value = !isPlayReadyTapped.value;
  final isImagePickerShown = false.obs;
  final waitingForOthersOpacity = 1.0.obs;
  RxBool isFinish = false.obs;
  bool get hideFooterButtons {
    if (itemHuntStatus.value != ItemHuntStatus.initial || isFinish.value) {
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
    _roomSubscription?.cancel();
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
        _roomRepository.roomStream(roomID).listen((roomSnapshot) async {
      if (!roomSnapshot.exists) {
        handleRoomClosure();
      } else {
        // Game Starts here
        await _updateRoomInfo(roomSnapshot);
      }
    }, onError: (error) {
      TLoggerHelper.info('$error');
    });
  }

  // Handle room closure
  void handleRoomClosure() {
    if (!isRoomLeader) {
      TPopup.warningSnackbar(
          title: TTexts.ohSnap, message: 'The room owner left the room');
    }
    Get.offAll(() => const HomeScreen());
  }

  // Update room info and start game if necessary
  Future<void> _updateRoomInfo(
      DocumentSnapshot<Map<String, dynamic>> roomSnapshot) async {
    roomInfo.value = RoomModel.fromSnapshot(roomSnapshot);
    if (roomInfo.value.gameState == GameState.progress &&
        roomInfo.value.items.isEmpty) {
      _startGame();
    }
  }

  Future<void> _startGame() async {
    try {
      await updateItems();
      Get.offAll(() => const MultiGameScreen());
      TPopup.customToast(message: 'Game Started');

      _startGameTimer();
      Timer.periodic(1.seconds, (_) {
        waitingForOthersOpacity.value =
            waitingForOthersOpacity.value == 1.0 ? 0.0 : 1.0;
      });

      // Rx listeners
      everAll(
        [score, itemLeft],
        (_) => _updatePlayerScoreAndItemLeft(),
      );
    } catch (e) {
      _handleError(e, '_startGame');
      rethrow;
    }
  }

  Future<void> updateItems() async {
    try {
      TFullScreenLoader.openLoadingDialog('Generating items');

      final response = await GeminiRepository.instance.loadHunt(
        roomInfo.value.huntLocation,
      );

      // Randomize items
      final items = (response.toList()..shuffle(math.Random()))
          .take(RoomPlayerModel.maxItems)
          .toList();

      // Update items
      await _roomRepository.updateItems(roomID, items);
      _items.addAll(items);
    } catch (e) {
      _handleError(e, 'update items');
      await _roomRepository.updateGameState(roomID, GameState.initial);
      TFullScreenLoader.stopLoading();
      rethrow;
    }
  }

  Future<void> _updatePlayerScoreAndItemLeft() async {
    try {
      await _roomRepository.updatePlayerScoreAndItemLeft(
        roomID,
        playerName,
        score.value,
        itemLeft.value,
      );
      checkIfAllPlayersDone();
      TLoggerHelper.info('Score: ${score.value}, Item left: ${itemLeft.value}');
    } catch (e) {
      _handleError(e, '_updatePlayerScoreAndItemLeft');
      TLoggerHelper.error(e.toString());
    }
  }

  // Starts game timer && Game Ends
  void _startGameTimer() {
    _stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      timeLeft.value--;
      if (timeLeft.value <= 0) {
        if (isImagePickerShown.value) {
          TLoggerHelper.info('message'); // TODO : Fix this
        }
        timer!.cancel();
        await endGame();
        TLoggerHelper.info('END GAME');
      }
    });
  }

  Future<void> quitRoom() async {
    try {
      if (isRoomLeader) {
        await _roomRepository.deleteRoom(roomID);
      } else {
        Get.offAll(() => const HomeScreen());
        await _roomRepository.removePlayerFromRoom(roomID, playerName);
      }
    } catch (e) {
      _handleError(e, 'Quit Room');
    }
  }

  Future<void> setReady() async {
    onPlayReadyTapped();
    try {
      await _roomRepository.updatePlayerReadyState(
        roomID,
        playerName,
        isReady.value = !isReady.value,
      );
    } catch (e) {
      _handleError(e, 'Set Ready');
    }
  }

  Future<void> startGame() async {
    onPlayReadyTapped();
    try {
      if (!shouldGenerateFakeItems) {
        final isAllReady = await _roomRepository.checkIfAllPlayersReady(roomID);
        if (isAllReady && roomInfo.value.players.length > 1) {
          // Update game state
          await _roomRepository.updateGameState(roomID, GameState.progress);
        } else {
          if (roomInfo.value.players.length > 1) {
            TPopup.customToast(message: 'Player(s) are not ready');
          } else {
            TPopup.warningSnackbar(
                title: 'Invite a fren', message: 'At least 2 player to start');
          }
        }
      } else {
        TFullScreenLoader.openLoadingDialog('Generating Items');
        _fakeItems.addAll(
            ['Remote', 'Cabinet', 'Lamp', 'Lighter', 'Coffe Cup', 'Outlet']);
        await _roomRepository.updateGameState(roomID, GameState.progress);
      }
    } catch (e) {
      _handleError(e, 'Start Game');
    }
  }

  Future<void> endGame() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      await _roomRepository.updateGameState(roomID, GameState.ended);
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  void checkIfAllPlayersDone() {
    final done = roomInfo.value.players.every((player) => player.itemLeft == 0);
    if (done) timeLeft.value = 0;
  }

  void onLeaveRoom() {
    CustomDialog.showOnLeaveDialog(
      title:
          isRoomLeader ? 'The room will be dismissed' : 'Confirm leaving room',
      subtitle: 'Are you sure you want to leave the room?',
      onLeavePressed: () => quitRoom(),
    );
  }

  // Game Progress methods ---------------------------------------------------------------------------------

  Future<void> validateImage() async {
    try {
      isImagePickerShown.value = true;
      final photo = await _photoPickerService.takePhoto();
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
    await Future.delayed(Durations
        .short1); // short delay so that the itemLeft and score doesn't race in firebase
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
        _resetTimer();
      } else {
        itemLeft.value--;
        isFinish.value = true;
        PlayerController.instance.updateMultiHighScore(score.value);
      }
    } catch (e) {
      rethrow;
    }
  }

  void incrementScore() {
    final scorePenalty = _stopwatch.elapsedMilliseconds ~/ 3000 * 1;
    score.value += 100 - math.min<int>(scorePenalty, 50);
  }

  // Handle generic errors
  void _handleError(Object e, String methodName) {
    TLoggerHelper.error('Error at [$methodName] : $e');
    TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
  }
}
