import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/frontend/pages/home_page.dart';
import 'package:todo_app/frontend/pages/show_todos.dart';

import '../api/api_service.dart';

class AddTodos extends StatefulWidget {
  const AddTodos({super.key});

  @override
  State<AddTodos> createState() => _AddTodosState();
}

class _AddTodosState extends State<AddTodos> {
  APIService myAPIService = APIService();
  TextEditingController Title = TextEditingController();
  TextEditingController Description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text("Create New Task",style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.black,
        // leading: Padding(
        //   padding: const EdgeInsets.only(top: 10),
        //   child: IconButton(onPressed: (){
        //     Navigator.of(context).pop();
        //   }, icon: Icon(CupertinoIcons.multiply,color: Colors.white,))
        // ),
      ),
      body: Column(
        children: [
          Padding (
            padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
            child: TextFormField(
              controller: Title,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              autocorrect: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white,fontSize: 22),
              decoration: InputDecoration(
                labelText: "Task Name",
                floatingLabelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 24,
                ),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 20),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
            child: TextFormField(
              controller: Description,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              autocorrect: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white,fontSize: 22),
              decoration: InputDecoration(
                  labelText: "Description",
                  floatingLabelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 24,
                  ),
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 20),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
            child: ElevatedButton(
              onPressed: () async{
                Map<String,dynamic> TodoData = {};
                TodoData["title"] = Title.text;
                TodoData["description"] = Description.text;
                await myAPIService.addTodo(TodoData);
                await myAPIService.fetchTodos();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
              },
              child: Text("Create Task",style: TextStyle(color: Colors.black,fontSize: 18),),
              style: ElevatedButton.styleFrom(minimumSize: Size(350, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),),
          )
        ],
      ),
    );
  }
}
