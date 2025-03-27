import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/frontend/pages/home_page.dart';
import '../api_services/api_service.dart';

class AddTodosScreen extends StatefulWidget {
  const AddTodosScreen({super.key});

  @override
  State<AddTodosScreen> createState() => _AddTodosScreenState();
}

class _AddTodosScreenState extends State<AddTodosScreen> {
  APIService myAPIService = APIService();
  TextEditingController Title = TextEditingController();
  TextEditingController Description = TextEditingController();
  String? selectedPriority = "Low";
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
          //Name For Todo
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
          //Priority For Todo
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
            child: DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: "Priority",
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 24),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.black, // Dropdown background color
              style: TextStyle(color: Colors.white, fontSize: 20),
              items: ["Low", "Medium", "High"].map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
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
                TodoData["priority"] = selectedPriority;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.4),)),
                );
                await myAPIService.addTodo(TodoData);
                await myAPIService.fetchTodos();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(initialIndex: 0),
                  ),
                      (route) => false, // for removing all previous routes
                );
              },
              child: Text("Create Task",style: TextStyle(color: Colors.black,fontSize: 18),),
              style: ElevatedButton.styleFrom(minimumSize: Size(350, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),),
          )
        ],
      ),
    );
  }
}
