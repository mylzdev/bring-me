import 'dart:async';

import 'package:bring_me/firebase_options.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bring_me.dart';
import 'src/core/config/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: Environment.filename);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) => Get.put(PlayerRepository()));
  runApp(const BringMe());
}
