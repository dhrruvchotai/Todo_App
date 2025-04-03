import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class Todo_APIService{
  //API 
  String? apiKeyTodos = dotenv.env['Todos_API'];

  //fetch todos from database using api
  Future<List<Map<String,dynamic>>> fetchTodos(String userId) async{
    try{
      final res = await http.get(Uri.parse(apiKeyTodos! + "/fetch/$userId"));
      if(res.statusCode == 200){
        print(List<Map<String,dynamic>>.from(jsonDecode(res.body)));
        return List<Map<String,dynamic>>.from(jsonDecode(res.body));
      }
    }
    catch(e){
      print("Error occurred while fetching all todos : $e");
    }
    return [];
  }

  //add todo to the database
  Future<void> addTodo(Map<String,dynamic> TodoData,String userId) async{
    try{
      print("This is TodoData $TodoData");
      final res = await http.post(
          Uri.parse(apiKeyTodos! + "/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(TodoData),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {  // Assuming success codes
        Map<String, dynamic> responseData = jsonDecode(res.body);
        print("Todo added successfully: $responseData");

      } else {
        print("Failed to add todo: ${res.body}");
      }
      await fetchTodos(userId);
    }
    catch(e){
      print("Error occurred in adding todo to the database : $e");
    }
  }

  //delete todos
  Future<void> deleteTodo(int todoId, Map<String,dynamic> userData) async{
    try{
        print("Todo Id : $todoId and User Data : $userData");
        final res = await http.delete(
          Uri.parse(apiKeyTodos! + "/delete/$todoId"),
          headers: <String,String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(userData)
        );

        if(res.statusCode == 200){
          print("Todo deleted successfully!");
          return;
        }
        else{
          print("Can not delete Todo!");
        }
    }
    catch(e){
      print("Error in deleting Todo : $e");
    }

  }

}