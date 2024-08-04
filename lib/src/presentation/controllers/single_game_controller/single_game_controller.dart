import 'dart:math' as math;

import 'package:bring_me/src/core/common/widgets/dialog/custom_dialog.dart';
import 'package:bring_me/src/core/config/lottie.dart';
import 'package:bring_me/src/core/config/text_strings.dart';
import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/core/utils/popups/popups.dart';
import 'package:bring_me/src/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/enums.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../data/repository/gemini_repository/gemini_client.dart';
import '../../../data/repository/gemini_repository/gemini_repository.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';
import '../home_controller/home_controller.dart';

class SingleGameController extends GetxController {
  static SingleGameController get instance => Get.find();
  SingleGameController(this.homeController);
  final HomeController homeController;

  final _photoPickerService = PhotoPickerService();
  final _stopwatch = Stopwatch();

  // State & Location
  Rx<GameState> gameState = GameState.initial.obs;
  Rx<HuntLocation> huntLocation = HuntLocation.indoor.obs;

  // Score
  final score = 0.obs;

  // Items
  final itemRandomizer =
      THelperFunctions.generateRandomInt(GeminiClient.maxGeneratedItems).obs;
  final itemLeft = 5.obs;
  final _items = <String>[].obs;
  Rx<ItemHuntStatus> itemHuntStatus = ItemHuntStatus.initial.obs;
  final RxList<int> calledItems = <int>[].obs;
  String get currentitem => _items[itemRandomizer.value];

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
    _generateUniqueItemRandomizer();
    calledItems.add(itemRandomizer.value);
    _stopwatch.start();
    huntLocation.value = homeController.huntLocation.value;
    homeController.gameState.listen((status) => gameState.value = status);
    homeController.items.listen((i) => _items.value = i);
    super.onInit();
  }

  @override
  void onClose() {
    _stopwatch.stop();
    super.onClose();
  }

  void skipItem() {
    try {
      if (itemLeft.value >= 2) {
        itemLeft.value--;
        _generateUniqueItemRandomizer();
        calledItems.add(itemRandomizer.value);
        _resetTimer();
      } else {
        itemLeft.value--;
        gameState.value = GameState.ended;

        String lottie;
        if (score >= 400) {
          lottie = LottieAsset.great;
        } else if (score > 300 && score < 400) {
          lottie = LottieAsset.good;
        } else {
          lottie = LottieAsset.meh;
        }
        CustomDialog.show(
          title: 'Final Score: ${score.value}',
          lottie: lottie,
          onRetry: retry,
          onContinue: () => Get.offAll(() => const HomeScreen()),
        );
      }
    } catch (e) {
      rethrow;
    }
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
        skipItem();
        _resetTimer();
      } else {
        // Photo not valid
        itemHuntStatus.value = ItemHuntStatus.validationFailure;
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
      itemHuntStatus.value = ItemHuntStatus.validationFailure;
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      itemHuntStatus.value = ItemHuntStatus.initial;
    }
  }

  void incrementScore() {
    final scorePenalty = _stopwatch.elapsedMilliseconds ~/ 2000 * 1;
    score.value += 100 - math.min<int>(scorePenalty, 50);
  }

  void _resetTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _generateUniqueItemRandomizer() {
    int newItem;
    do {
      newItem =
          THelperFunctions.generateRandomInt(GeminiClient.maxGeneratedItems);
    } while (calledItems.contains(newItem));
    itemRandomizer.value = newItem;
  }

  void retry() async {
    try {
      score.value = 0;
      itemLeft.value = 5;
      calledItems.clear();
      _items.clear();
      CustomDialog.close();
      gameState.value = GameState.initial;
      final response =
          await GeminiRepository.instance.loadHunt(huntLocation.value);
      _items.value = response;
      gameState.value = GameState.progress;
    } catch (e) {
      Get.offAll(() => const HomeScreen());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  void onLeaveGame() async {
    await Get.defaultDialog(
      title: 'The data will be lost',
      middleText: 'Are you sure you want to leave the room?',
      contentPadding: EdgeInsets.all(TSizes.defaultSpace),
      titlePadding: EdgeInsets.only(top: TSizes.defaultSpace),
      confirm: ElevatedButton(
        onPressed: () => Get.offAll(() => const HomeScreen()),
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
}
