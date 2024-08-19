import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/config/enums.dart';
import '../../../core/utils/exceptions/gemini_exception.dart';
import '../room_repository/room_player_model.dart';
import 'gemini_client.dart';

class GeminiRepository extends GetxService {
  static GeminiRepository get instance => Get.find();
  final _client = GeminiClient();

  Future<List<String>> loadItems(HuntLocation gameLocation) async {
    final location = switch (gameLocation) {
      HuntLocation.indoor => 'at home',
      HuntLocation.outdoor => 'outside',
    };
    try {
      final response = await _client.generateScavengerHuntItems(location);

      if (response == null) {
        throw const GeminiRepositoryException(
            'Failed to get response from Gemini');
      }

      if (jsonDecode(response) case {'items': List<dynamic> items}) {
        final generatedItems = List<String>.from(items);

        final shuffledItems = (generatedItems..shuffle(math.Random()))
            .take(RoomPlayerModel.maxItems)
            .toList();

        return shuffledItems;
      }

      throw const GeminiRepositoryException('Invalid response from Gemini');
    } on GenerativeAIException catch (_) {
      throw const GeminiRepositoryException(
          'Problem with the Generative AI service');
    } catch (e) {
      throw 'Problem with Generative AI Service. Please try again';
    }
  }

  Future<bool> validateImage(String item, Uint8List image) async {
    try {
      final response = await _client.validateImage(item, image);

      if (response == null) {
        throw const GeminiRepositoryException(
            'Failed to get response from Gemini');
      }

      if (jsonDecode(response) case {'valid': bool valid}) return valid;

      throw const GeminiRepositoryException('Invalid response from Gemini');
    } on GenerativeAIException {
      throw const GeminiRepositoryException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      throw 'Problem with Generative AI Service. Please try again';
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
      throw 'Problem with Generative AI Service. Please try again';
    }
  }
}
