import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get filename {
    // if (kReleaseMode) {
    //   return '.env';
    // }
    return '.env';
  }

  static String get apiKey => dotenv.get('API_KEY', fallback: 'API KEY NOT FOUND');
}
