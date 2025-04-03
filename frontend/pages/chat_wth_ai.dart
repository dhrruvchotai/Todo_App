import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/frontend/ai_services/google_generativeai_service.dart';

class ChatWithAIScreen extends StatefulWidget {
  const ChatWithAIScreen({super.key});

  @override
  State<ChatWithAIScreen> createState() => _ChatWithAIScreenState();
}

class _ChatWithAIScreenState extends State<ChatWithAIScreen> {
  GoogleAIService AIServices = GoogleAIService();
  TextEditingController Prompt = TextEditingController();
  String? userName,userId;
  String response = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedpref.getString("userName") ?? "Guest";
      userId = sharedpref.getString("userId") ?? "Guest_25";
      print("User Id $userId and User Name $userName from chat with AI.");
    });
  }

  Future<void> getAIResponse() async {
    setState(() {
      isLoading = true;
    });

    String aiReply = await AIServices.getResponseForGivenPrompt(Prompt.text,userId!);

    setState(() {
      response = aiReply;
      isLoading = false;
    });

    Prompt.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text("Chat With AI", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: TextFormField(
                controller: Prompt,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                autocorrect: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                  labelText: "Enter Your Prompt",
                  floatingLabelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 24,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3), fontSize: 20),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: ElevatedButton(
                onPressed: getAIResponse,
                child: Text("Get Answer",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            if (response.isNotEmpty)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        response,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
