import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/config/environment.dart';

class GeminiClient {
  // final generatedItems = RxList<String>();
  static const maxGeneratedItems = 100;

  final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: Environment.apiKey,
  );

  Future<String?> generateScavengerHuntItems(String location) async {
    final prompt =
        'You are a scavenger hunt game where objects are found by taking a photo of them.'
        'Generate a list of $maxGeneratedItems tangible items that could be found in the following: $location.'
        'The difficulty to find the items should be easy'
        'Keep the item name concise. All letters should be uppercase. Do not include articles (a, an, the).'
        'Provide your response as a JSON object with the following schema: {"items": ["", "", ...]}.'
        'Do not return your result as Markdown.';

    final response = await _model.generateContent([Content.text(prompt)]);
    final content = response.text;

    // if (jsonDecode(content!) case {'items': List<dynamic> items}) {
    //   final contentItems = List<String>.from(items);
    //   generatedItems.addAll(contentItems);
    //   if (generatedItems.length > 150) {
    //     generatedItems.clear();
    //   }
    // }

    return content;
  }

  Future<String?> validateImage(String item, Uint8List image) async {
    final prompt =
        'You are a scavenger hunt game where objects are found by taking a photo of them.'
        'You have been given the item "$item" and a photo of the item.'
        'Determine if the photo is a valid photo of the item.'
        'Provide your response as a JSON object with the following schema: {"valid": true/false}.'
        'Do not return your result as Markdown.';

    final response = await _model.generateContent([
      Content.multi([TextPart(prompt), DataPart('image/jpeg', image)]),
    ]);

    return response.text;
  }

  Future<String?> generateUsername() async {
    const prompt =
        'Generate a 50 unique and memorable username. It should be short, easy to remember,'
        'and preferably not already taken. Consider using a combination of words, numbers, symbols'
        'It should not have any spaces or emoticons and preferably not taken'
        'The username should be at least 3 characters short and will not exceed to 10 characters'
        'Do not add this ```json or anything at the start of your result'
        'Provide your response as a JSON object with the following schema: {"items": ["", "", ...]}.'
        'Do not return your result as Markdown.';

    final response = await _model.generateContent([Content.text(prompt)]);
    final content = response.text;

    return content;
  }
}
