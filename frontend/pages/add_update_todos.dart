import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/frontend/pages/home_page.dart';
import '../api_services/todo_api_service.dart';

class AddUpdateTodosScreen extends StatefulWidget {
  //Details to update the todo
  final String? todoId;
  final Map<String,dynamic>? todoToEdit;

  const AddUpdateTodosScreen({super.key, this.todoToEdit, this.todoId});
  @override
  State<AddUpdateTodosScreen> createState() => _AddUpdateTodosScreenState();
}

class _AddUpdateTodosScreenState extends State<AddUpdateTodosScreen> {

  Todo_APIService todoAPIService = Todo_APIService();
  TextEditingController Title = TextEditingController();
  TextEditingController Description = TextEditingController();
  String? selectedPriority = "Low";
  String? userId,userName;
  Future<List<Map<String, dynamic>>>? futureTodos;

  @override
  void initState() {
    super.initState();
    initializeData();

    //check that if we want to add the data or edit the data
    if(widget.todoToEdit != null){
      Title.text = widget.todoToEdit!["title"] ?? "No Title";
      Description.text = widget.todoToEdit!["description"] ?? "No description provided!";
      selectedPriority = widget.todoToEdit!["priority"] ?? "Low";
    }
  }

  Future<void> initializeData() async {
    await getUserData();
    setState(() {
      futureTodos = todoAPIService.fetchTodos(userId!);
    });
  }

  Future<void> getUserData() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedpref.getString("userName") ?? "Guest";
      userId = sharedpref.getString("userId") ?? "Guest_25";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Create New Task",style: TextStyle(color: Colors.white,fontSize: 26),),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
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
                  TodoData["userId"] = userId;
                  TodoData["title"] = Title.text;
                  TodoData["description"] = Description.text;
                  TodoData["priority"] = selectedPriority;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.4),)),
                  );

                  //check if we want to edit the todo or update the todo
                  if(widget.todoToEdit != null && widget.todoId != null){
                    await todoAPIService.updateTodo(widget.todoId!,TodoData);
                  }
                  else{
                    await todoAPIService.addTodo(TodoData,userId!);
                  }
                  //after adding updating todo fetch all
                  await todoAPIService.fetchTodos(userId!);

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomePage(initialIndex: 0),
                    ),
                        (route) => false, // to remove all previous routes
                  );
                },
                child: Text( (widget.todoToEdit != null && widget.todoId != null) ? "Update Task" : "Create Task", style: TextStyle(color: Colors.black,fontSize: 18),),
                style: ElevatedButton.styleFrom(minimumSize: Size(350, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),),
            )
          ],
        ),
      ),
    );
  }
}
