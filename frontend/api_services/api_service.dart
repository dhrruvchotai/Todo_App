import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class APIService{
  //API 
  String? apiKeyTodos = dotenv.env['Todos_API'];
  String? apiKeyAuth = dotenv.env['Auth_API'];

  //sign up user
  Future<void> createAccount(userName,email,password,confirmPassword) async{
    try{
      final res = await http.post(Uri.parse(apiKeyAuth! + "/signup"));
      if(res.statusCode == 201){
        print("User created successfully : ${res.body}");
      }
      else{
        print("Can not create user account!");
      }
    }
    catch(e){
      print("Error while creating user account : $e");
    }
  }

  //fetch todos from database using api
  Future<List<Map<String,dynamic>>> fetchTodos() async{
    try{
      final res = await http.get(Uri.parse(apiKeyTodos! + "/fetch"));
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
  Future<void> addTodo(Map<String,dynamic> TodoData) async{
    try{
      print("Add Todo Method Called!");
      print("This is TodoData $TodoData");
      final res = await http.post(
          Uri.parse(apiKeyTodos! + "/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(TodoData),
      );
      await fetchTodos();
    }
    catch(e){
      print("Error occurred in adding todo to the database : $e");
    }
  }
}