import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bring_me.dart';
import 'firebase_options.dart';
import 'src/core/config/environment.dart';
import 'src/data/repository/player_repository/player_repository.dart';
import 'src/data/services/internet/internet_service.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  await dotenv.load(fileName: Environment.filename);
  await GoogleFonts.pendingFonts([
    GoogleFonts.playfair(),
    GoogleFonts.poppins(),
    GoogleFonts.blackHanSans(),
  ]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(InternetService());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) => Get.put(PlayerRepository()));
  runApp(const BringMe());
}
