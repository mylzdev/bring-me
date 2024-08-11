import 'dart:async';

import 'package:bring_me/src/core/utils/device/local_storage_key.dart';
import 'package:bring_me/src/core/utils/popups/loader.dart';
import 'package:bring_me/src/data/repository/player_repository/player_avatar_model.dart';
import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/config/text_strings.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/popups.dart';
import '../../screens/home/home.dart';

class PlayerController extends GetxController {
  static PlayerController get instance => Get.find();

  final _localStorage = GetStorage();
  final _playerRepository = PlayerRepository.instance;

  // late RxList<String> generatedUsernames = <String>[].obs;
  // final isGeneratingUsernames = true.obs;

  Rx<PlayerModel> playerInfo = PlayerModel.empty().obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _playerSubscription;

  // Avatar Selection
  final avatarIndex = 0.obs;
  String get playerAvatar =>
      PlayerAvatarModel.avatars[playerInfo.value.avatarIndex];

  // Username
  final usernameController = TextEditingController();
  GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    streamPlayerInfo(_playerRepository.username.value);
    super.onInit();
  }

  @override
  void onClose() {
    _playerSubscription?.cancel();
    super.onClose();
  }

  Future<void> createUsername() async {
    try {
      if (!usernameFormKey.currentState!.validate()) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.openLoadingDialog('Loading'),
      );

      final playerModel = PlayerModel(
        username: usernameController.text,
        avatarIndex: avatarIndex.value,
      );

      playerInfo.value = playerModel;
      await _playerRepository.saveUsername(playerModel);

      _localStorage.write(TLocalStorageKey.username, usernameController.text);
      _playerRepository.username.value = usernameController.text;
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.stopLoading(),
      );
    }
  }

  void streamPlayerInfo(String username) {
    try {
      if (username.isNotEmpty || username != '') {
        _playerSubscription =
            _playerRepository.playerStream(username).listen((playerSnapshot) {
          if (playerSnapshot.exists) {
            playerInfo.value = PlayerModel.fromSnapshot(playerSnapshot);
            TLoggerHelper.info(playerInfo.value.toString());
          } else {
            throw 'Username does not exist';
          }
        });
      } else {
        TLoggerHelper.warning('Username does not exist');
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  Future<void> updateSingleHighScore(int newSingleScore) async {
    try {
      await _playerRepository.updateSingleGameScore(newSingleScore);
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TLoggerHelper.error(e.toString());
    }
  }

  // Generating usernames with gemini

  // Future<void> navigateToAuth() async {
  // try {
  //   if (isGeneratingUsernames.value) {
  //     TFullScreenLoader.openLoadingDialog('Loading');
  //     await generateUsernames();
  //   }
  //   TFullScreenLoader.stopLoading();
  //   Get.off(() => const AvatarSelection());
  // } catch (e) {
  //   TLoggerHelper.error(e.toString());
  // }
  // Get.off(() => const AvatarSelection());
  // }

  // Future<void> generateUsernames() async {
  //   try {
  //     final usernames = await GeminiRepository.instance.generateUsername();
  //     generatedUsernames.addAll(usernames);
  //     refreshUsername();
  //   } catch (e) {
  //     TLoggerHelper.error(e.toString());
  //   }
  // }

  // void refreshUsername() {
  //   usernameController.text =
  //       generatedUsernames[Random().nextInt(generatedUsernames.length)].trim();
  // }
}
