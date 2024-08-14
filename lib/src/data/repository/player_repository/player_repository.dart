import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../core/utils/exceptions/firebase_auth_exceptions.dart';
import '../../../core/utils/exceptions/firebase_exceptions.dart';
import '../../../core/utils/exceptions/format_exceptions.dart';
import '../../../core/utils/exceptions/platform_exceptions.dart';
import '../../../presentation/screens/auth/welcome.dart';
import '../../../presentation/screens/home/home.dart';
import '../../services/internet/internet_service.dart';
import 'player_model.dart';

class PlayerRepository extends GetxService {
  static PlayerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? get authUser => _auth.currentUser;

  final _internet = InternetService.instance;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
    super.onReady();
  }

  screenRedirect() async {
    final user = _auth.currentUser;
    final isConnected = await _internet.isConnected();
    if (user == null && isConnected) {
      Get.offAll(() => const WelcomeScreen());
    } else if (user != null && isConnected) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const Scaffold());
      _internet.showNoInternetDialog(shouldRedirectToHome: true);
    }
  }

  Future<UserCredential> signinAnonymous() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while signing anonymously';
    }
  }

  Future<void> savePlayer(PlayerModel player) async {
    try {
      await _db.collection('Users').doc(player.id).set(player.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while creating a user. Please try again';
    }
  }

  Future<void> updatePlayerName(String newUsername) async {
    try {
      final userRef = _db.collection('Users').doc(_auth.currentUser!.uid);
      final playerSnapshot = await userRef.get();

      PlayerModel updatedPlayerInfo = PlayerModel.fromSnapshot(playerSnapshot);
      updatedPlayerInfo = updatedPlayerInfo.copyWith(username: newUsername);

      await userRef.update(updatedPlayerInfo.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating player name. Please try again';
    }
  }

  Future<void> updatePlayerAvatar(int newAvatar) async {
    try {
      final userRef = _db.collection('Users').doc(_auth.currentUser!.uid);
      final playerSnapshot = await userRef.get();

      PlayerModel updatedPlayerInfo = PlayerModel.fromSnapshot(playerSnapshot);
      updatedPlayerInfo = updatedPlayerInfo.copyWith(avatarIndex: newAvatar);

      await userRef.update(updatedPlayerInfo.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating player avatar. Please try again';
    }
  }

  Future<void> updateSingleGameScore(int singleGameScore) async {
    try {
      final userRef = _db.collection('Users').doc(_auth.currentUser!.uid);
      final playerSnapshot = await userRef.get();

      PlayerModel player = PlayerModel.fromSnapshot(playerSnapshot);
      int updatedSingleHighscore = player.singleGameScore > singleGameScore
          ? player.singleGameScore
          : singleGameScore;
      player = player.copyWith(singleGameScore: updatedSingleHighscore);

      await userRef.update(player.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating single game score. Please try';
    }
  }

  Future<void> updateMultiGameScore(int mulitGameScore) async {
    try {
      final userRef = _db.collection('Users').doc(_auth.currentUser!.uid);
      final playerSnapshot = await userRef.get();

      PlayerModel player = PlayerModel.fromSnapshot(playerSnapshot);
      int updatedSingleHighscore = player.singleGameScore > mulitGameScore
          ? player.multiGameScore
          : mulitGameScore;
      player = player.copyWith(multiGameScore: updatedSingleHighscore);

      await userRef.update(player.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating to player multigame score';
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> playerStream() {
    try {
      return _db.collection('Users').doc(_auth.currentUser!.uid).snapshots();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while listening to player: $e';
    }
  }

  Stream<User?> authStateChanges() {
    try {
      return _auth.authStateChanges();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Error while listening to auth changes: $e';
    }
  }
}
