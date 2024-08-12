import 'dart:math' as math;

import 'package:bring_me/src/core/common/widgets/dialog/custom_dialog.dart';
import 'package:bring_me/src/core/config/lottie.dart';
import 'package:bring_me/src/core/config/text_strings.dart';
import 'package:bring_me/src/core/utils/device/local_storage_key.dart';
import 'package:bring_me/src/core/utils/popups/popups.dart';
import 'package:bring_me/src/presentation/controllers/player_controller/player_controller.dart';
import 'package:bring_me/src/presentation/screens/home/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/config/enums.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../../data/repository/room_repository/room_player_model.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';
import '../home_controller/home_controller.dart';

class SingleGameController extends GetxController {
  static SingleGameController get instance => Get.find();
  SingleGameController(this.homeController);
  final HomeController homeController;

  final _localStorage = GetStorage();

  final _photoPickerService = PhotoPickerService();
  final _stopwatch = Stopwatch();

  // State & Location
  Rx<GameState> gameState = GameState.initial.obs;
  Rx<HuntLocation> huntLocation = HuntLocation.indoor.obs;

  // Score
  final score = 0.obs;
  final highscore = 0.obs;

  // Items

  final itemLeft = RoomPlayerModel.maxItems.obs;
  final _items = <String>[].obs;
  Rx<ItemHuntStatus> itemHuntStatus = ItemHuntStatus.initial.obs;
  String get currentitem => _items[itemLeft.value - 1];

  bool get hideFooterButtons {
    if (itemHuntStatus.value != ItemHuntStatus.initial ||
        gameState.value == GameState.initial ||
        gameState.value == GameState.ended) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    setHighScore();
    _stopwatch.start();
    huntLocation.value = homeController.huntLocation.value;
    homeController.gameState.listen((status) => gameState.value = status);
    homeController.items.listen((i) => _items.value = i);
    super.onInit();
  }

  void setHighScore() {
    _localStorage.writeIfNull(TLocalStorageKey.singleGameHighScore, 0);
    final hs = _localStorage.read(TLocalStorageKey.singleGameHighScore);
    highscore.value = hs;
  }

  @override
  void onClose() {
    _stopwatch.stop();
    super.onClose();
  }

  void skipItem() async {
    try {
      if (itemLeft.value >= 2) {
        itemLeft.value--;
        _resetTimer();
      } else {
        gameEnds();
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  void gameEnds() async {
    gameState.value = GameState.ended;

    bool isNewHighScore = false;
    if (score.value > highscore.value) {
      _localStorage.write(TLocalStorageKey.singleGameHighScore, score.value);
      isNewHighScore = true;
    }

    CustomDialog.show(
      title: isNewHighScore
          ? 'New High Score: ${score.value}'
          : 'Final Score ${score.value}',
      lottie: getLottieBaseScore(score.value),
      onRetry: retry,
      onContinue: () => Get.offAll(() => const HomeScreen()),
    );
    await PlayerController.instance.updateSingleHighScore(score.value);
  }

  String getLottieBaseScore(int score) {
    String lottie;
    if (score >= 400) {
      lottie = LottieAsset.great;
    } else if (score > 300 && score < 400) {
      lottie = LottieAsset.good;
    } else {
      lottie = LottieAsset.meh;
    }
    return lottie;
  }

  Future<void> validateImage() async {
    try {
      final photo = await _photoPickerService.pickPhoto();
      itemHuntStatus.value = ItemHuntStatus.validationInProgress;
      final isPhotoValid =
          await GeminiRepository.instance.validateImage(currentitem, photo);
      if (isPhotoValid) {
        // Photo valid
        incrementScore();
        itemHuntStatus.value = ItemHuntStatus.validationSuccess;
        await resetItemStatus();
        skipItem();
        _resetTimer();
      } else {
        // Photo not valid
        itemHuntStatus.value = ItemHuntStatus.validationFailure;
        resetItemStatus();
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
      itemHuntStatus.value = ItemHuntStatus.validationFailure;
      resetItemStatus();
    }
  }

  Future<void> resetItemStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    itemHuntStatus.value = ItemHuntStatus.initial;
  }

  void incrementScore() {
    final scorePenalty = _stopwatch.elapsedMilliseconds ~/ 2000 * 1;
    score.value += 100 - math.min<int>(scorePenalty, 50);
  }

  void _resetTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void retry() async {
    try {
      score.value = 0;
      itemLeft.value = 5;
      _items.clear();
      CustomDialog.close();
      gameState.value = GameState.initial;

      final response =
          await GeminiRepository.instance.loadHunt(huntLocation.value);
      // Randomize items
      final shuffledItems = (response.toList()..shuffle(math.Random()))
          .take(RoomPlayerModel.maxItems)
          .toList();
      _items.value = shuffledItems;

      gameState.value = GameState.progress;
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  void onLeaveGame() {
    CustomDialog.showOnLeaveDialog(
      title: 'The data might be lost',
      subtitle: 'Are you sure you want to leave the room?',
      onLeavePressed: () => Get.offAll(() => const HomeScreen()),
    );
  }
}
