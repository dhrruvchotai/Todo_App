import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String? Google_GenerativeAI_API = dotenv.env['Google_GenerativeAI_API'];

  Future<String> getResponseForGivenPrompt(String prompt) async {

    if (Google_GenerativeAI_API! == null || Google_GenerativeAI_API!.isEmpty) {
      return "API Key is missing or invalid.";
    }

    try {

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: Google_GenerativeAI_API!,
      );
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      print("Here is the response for your prompt: ${response.text}");
      return response.text ?? "No response from AI.";
    }
    catch (e) {
      print("An error occurred while fetching response from AI: $e");
      return "An error occurred while processing your request.";
    }
  }
}
