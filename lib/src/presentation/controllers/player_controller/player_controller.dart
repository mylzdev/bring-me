import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/config/text_strings.dart';
import '../../../core/utils/device/local_storage_key.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/loader.dart';
import '../../../core/utils/popups/popups.dart';
import '../../../data/repository/player_repository/player_avatar_model.dart';
import '../../../data/repository/player_repository/player_model.dart';
import '../../../data/repository/player_repository/player_repository.dart';
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

  StreamSubscription<User?>? _authSubscription;

  // Avatar Selection
  final avatarIndex = 0.obs;
  final isAvatarHeaderSelected = true.obs;
  String get playerAvatar =>
      PlayerAvatarModel.avatars[playerInfo.value.avatarIndex];

  // Username
  final usernameController = TextEditingController();
  GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();
  String get playername => playerInfo.value.username;

  @override
  Future<void> onInit() async {
    streamPlayerInfo();
    super.onInit();
  }

  @override
  void onClose() {
    _playerSubscription?.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> createPlayer() async {
    try {
      if (!usernameFormKey.currentState!.validate()) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.openLoadingDialog('Loading'),
      );

      final userCredential = await _playerRepository.signinAnonymous();

      final playerModel = PlayerModel(
        id: userCredential.user!.uid,
        username: usernameController.text,
        avatarIndex: avatarIndex.value,
      );

      playerInfo.value = playerModel;
      await _playerRepository.savePlayer(playerModel);

      _localStorage.write(TLocalStorageKey.avatarIndex, avatarIndex.value);
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.stopLoading(),
      );
    }
  }

  Future<void> updatePlayerName(String updatedName) async {
    try {
      if (!usernameFormKey.currentState!.validate()) return;

      TFullScreenLoader.openLoadingDialog('Updating');

      await _playerRepository.updatePlayerName(updatedName);
      TFullScreenLoader.stopLoading();
      Get.back();
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> updatePlayerAvatar(int index) async {
    try {
      TFullScreenLoader.openLoadingDialog('Updating');

      await _playerRepository.updatePlayerAvatar(index);
      TLoggerHelper.info('message');
      avatarIndex.value = index;
      TFullScreenLoader.stopLoading();
      Get.back();
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TFullScreenLoader.stopLoading();
    }
  }

  void streamPlayerInfo() {
    try {
      if (_playerRepository.authUser?.uid != null) {
        _playerSubscription = _playerRepository.playerStream().listen(
          (playerSnapshot) {
            if (playerSnapshot.exists) {
              playerInfo.value = PlayerModel.fromSnapshot(playerSnapshot);
              avatarIndex.value = playerInfo.value.avatarIndex;
              usernameController.text = playerInfo.value.username;
              TLoggerHelper.info(playerInfo.value.toString());
            } else {
              TLoggerHelper.warning('Player does not exist.');
            }
          },
          onError: (e) {
            TLoggerHelper.error(e);
          }
        );
      } else {
        _listenToAuthChanges();
      }
    } catch (e) {
      TLoggerHelper.error('Error starting stream: $e');
    }
  }

  void _listenToAuthChanges() {
    _authSubscription = _playerRepository.authStateChanges().listen((user) {
      if (user != null) {
        streamPlayerInfo();
      } else {
        TLoggerHelper.info('User is not authenticated.');
      }
    });
  }

  Future<void> updateSingleHighScore(int newSingleScore) async {
    try {
      await _playerRepository.updateSingleGameScore(newSingleScore);
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      TLoggerHelper.error(e.toString());
    }
  }

  Future<void> updateMultiHighScore(int newMultiScore) async {
    try {
      await _playerRepository.updateMultiGameScore(newMultiScore);
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
