import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/frontend/api_services/todo_api_service.dart';

class GoogleAIService {
  //API
  final String? Google_GenerativeAI_API = dotenv.env['Google_GenerativeAI_API'];
  
  //TodoService to fetch all todos for user
  Todo_APIService TodoAPIService = Todo_APIService();

  GoogleAIService() {
    if (Google_GenerativeAI_API == null || Google_GenerativeAI_API!.isEmpty) {
      throw Exception("API Key is missing or invalid.");
    }
  }

  Future<String> generatePrompt(String userMessage, String userId) async{

    try{
      List<Map<String, dynamic>> todos = await TodoAPIService.fetchTodos(userId);

      String todoList = todos.isNotEmpty
          ? todos.map((todo) => "- (Title : ${todo['title']}) (Description : ${todo['description']}) (Priority : ${todo['priority']}) ").join("\n")
          : "You have no tasks added.";

      return """
        You are an AI assistant helping users with their to-do list.
        The user's tasks:
        $todoList
        The user asked: "$userMessage"
        Respond based on the user's tasks and be helpful.
      """;
    }
    catch(e){
      print("Error generating in Prompt : $e");
    }
    return userMessage;
  }
  //Method to get response
  Future<String> getResponseForGivenPrompt(String userMessage,String userId) async {

    if (Google_GenerativeAI_API! == null || Google_GenerativeAI_API!.isEmpty) {
      return "API Key is missing or invalid.";
    }

    try {

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: Google_GenerativeAI_API!,
      );
      final prompt = await generatePrompt(userMessage,userId);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      String cleanedResponse = removeMarkdown(response.text ?? "No response from AI.");

      return cleanedResponse;
    }
    catch (e) {
      print("An error occurred while fetching response from AI: $e");
      return "An error occurred while processing your request.";
    }
  }

  String removeMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'\*'), '')
        .replaceAll(RegExp(r'_'), '');
  }
}
