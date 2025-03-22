import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class APIService{
  
  //API 
  String? apiKey = dotenv.env['API'];
  
  Future<List<Map<String,dynamic>>> fetchTodos() async{
    try{
      final res = await http.get(Uri.parse(apiKey! + "/fetch"));
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
}