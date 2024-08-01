import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:bring_me/src/presentation/screens/auth/welcome.dart';
import 'package:bring_me/src/presentation/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/device/local_storage_key.dart';
import '../../../core/utils/exceptions/firebase_exceptions.dart';
import '../../../core/utils/exceptions/format_exceptions.dart';
import '../../../core/utils/exceptions/platform_exceptions.dart';

class PlayerRepository extends GetxService {
  static PlayerRepository get instance => Get.find();

  final _localStorage = GetStorage();

  late RxString? generatedUsername = ''.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxString username = ''.obs;

  @override
  void onReady() {
    final user = _localStorage.read(TLocalStorageKey.username);
    screenRedirect(user);
    super.onReady();
  }

  @override
  void onInit() {
    final user = _localStorage.read(TLocalStorageKey.username);
    if (user != null) {
      username.value = user;
    }
    super.onInit();
  }

  screenRedirect(dynamic username) async {
    if (username == null || username == '') {
      Get.offAll(() => const WelcomeScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> saveUsername(PlayerModel user) async {
    try {
      final userRef = _db.collection('Users').doc(user.name);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        throw 'username-taken';
      }

      await userRef.set(user.toMap());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (e == 'username-taken') {
        throw 'Username already taken';
      }
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> playerStream(String username) {
    try {
      return _db.collection('Users').doc(username).snapshots();
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
}
