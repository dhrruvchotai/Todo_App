import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class Auth_APIService{
  //API
  String? apiKeyAuth = dotenv.env['Auth_API'];

  //sign up user
  Future<bool> createAccount(Map<String,dynamic> userData) async{
    try{
      final res = await http.post(
        Uri.parse(apiKeyAuth! + "/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      if(res.statusCode == 201){
        print("User created successfully : ${res.body}");
        Map<String,dynamic> responseData = jsonDecode(res.body);
        String userId = responseData['user']['_id'];
        String userName = responseData['user']['userName'];
        print("User ID : $userId and User Name : $userName");
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("userId", userId);
        sharedPref.setString("userName", userName);
        return true;
      }
      else{
        print("Can not create user account : ${res.body}");
      }
    }
    catch(e){
      print("Error while creating user account : $e");
    }
    return false;
  }

  Future<bool> loginIntoAccount(Map<String,dynamic> userData) async{
    try{
      print("User Data is : ${userData}");
      final res = await http.post(
        Uri.parse(apiKeyAuth! + "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if(res.statusCode == 200){
        print("Logged into your account successfully! : ${res.body}");
        Map<String,dynamic> responseData = jsonDecode(res.body);
        String userId = responseData['userId'];
        String userName = responseData['user']['userName'];
        print("User ID : $userId and User Name : $userName");
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("userId", userId);
        sharedPref.setString("userName", userName);
        return true;
      }
      else{
        print("Can not login into your account : ${res.body}");
      }
    }
    catch(e){
      print("Error occurred while logging into the account!");
    }
    return false;
  }
}