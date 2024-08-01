import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/config/enums.dart';
import '../../../core/utils/exceptions/gemini_exception.dart';
import '../../../core/utils/logging/logger.dart';
import 'gemini_client.dart';

class GeminiRepository extends GetxService {
  static GeminiRepository get instance => Get.find();
  final _client = GeminiClient();

  Future<List<String>> loadHunt(HuntLocation gameLocation) async {
    final location = switch (gameLocation) {
      HuntLocation.indoor => 'at home',
      HuntLocation.outdoor => 'outside',
    };
    try {
      final response = await _client.generateScavengerHuntItems(location);

      if (response == null) {
        throw const GeminiRepositoryException('Response is empty');
      }

      if (jsonDecode(response) case {'items': List<dynamic> items}) {
        return List<String>.from(items);
      }

      throw const GeminiRepositoryException('Invalid JSON schema');
    } on GenerativeAIException catch (e) {
      throw GeminiRepositoryException(
          'Problem with the Generative AI service: $e');
    } catch (e) {
      if (e is GeminiRepositoryException) rethrow;

      throw const GeminiRepositoryException();
    }
  }

  Future<bool> validateImage(String item, Uint8List image) async {
    try {
      final response = await _client.validateImage(item, image);

      if (response == null) {
        throw const GeminiRepositoryException('Response is empty');
      }

      if (jsonDecode(response) case {'valid': bool valid}) return valid;

      throw const GeminiRepositoryException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminiRepositoryException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      TLoggerHelper.error(e.toString());
      if (e is GeminiRepositoryException) rethrow;

      throw const GeminiRepositoryException();
    }
  }

  Future<List<String>> generateUsername() async {
    try {
      final response = await _client.generateUsername();

      if (jsonDecode(response!) case {'items': List<dynamic> items}) {
        return List<String>.from(items);
      }

      throw const GeminiRepositoryException('Invalid JSON schema');
    } catch (e) {
      TLoggerHelper.error(e.toString());
      if (e is GeminiRepositoryException) rethrow;

      throw const GeminiRepositoryException();
    }
  }
}
