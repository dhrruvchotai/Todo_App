
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todo_app/frontend/api_services/todo_api_service.dart';
import 'package:todo_app/frontend/pages/add_update_todos.dart';
import 'package:todo_app/frontend/pages/home_page.dart';

class ShowTodosScreen extends StatefulWidget {
  const ShowTodosScreen({super.key});

  @override
  State<ShowTodosScreen> createState() => _ShowTodosScreenState();
}

class _ShowTodosScreenState extends State<ShowTodosScreen> {
  Todo_APIService TodoAPIService = Todo_APIService();
  Future<List<Map<String, dynamic>>>? futureTodos;
  String? userName,userId;
  Set<int> expandedItems = {};

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getUserData();
    setState(() {
      futureTodos = TodoAPIService.fetchTodos(userId!);
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
        toolbarHeight: 80,
        leadingWidth: 200,
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Hello ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$userName 👋",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircleAvatar(
              child: Icon(Icons.notifications_none_rounded,color: Colors.white,),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Manage Your",style: TextStyle(color: Colors.white,fontSize: 29),),
                    Text("Daily Task",style: TextStyle(color: Colors.white,fontSize: 27),)
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: futureTodos,
                builder: (context, snapshot) {
                  //show skeletonizer here when all todos are in the loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.5),));
                    return Skeletonizer(effect: ShimmerEffect(),enabled: true,
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:Colors.white.withOpacity(0.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: IntrinsicWidth(
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  // color:getPriorityColor(snapshot.data![index]["priority"]),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  child: Center(child: Text("Low",style: TextStyle(color: Colors.white),)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                             DateFormat('dd-MM-yyyy').format(DateTime.now()), style: TextStyle(color: Colors.white,fontSize: 17),)
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,left: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "No Title",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.white,fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,left: 14),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "No Description Available!",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,left: 14),
                                        child: Row(
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.not_interested_rounded),
                          Text("No Todos Found!"),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:Colors.white.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 7),
                                            child: IntrinsicWidth(
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color:getPriorityColor(snapshot.data![index]["priority"]),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  child: Center(child: Text(snapshot.data![index]["priority"] ?? "Low",style: TextStyle(color: Colors.white),)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 1.4,
                                            child: Checkbox(
                                              value:snapshot.data![index]["completed"] ?? false,
                                              onChanged: (bool? value) async {
                                                if (value == true) {
                                                  Map<String, dynamic> userData = {};
                                                  userData["userId"] = userId;
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) => Center(child: CircularProgressIndicator(
                                                        color: Colors.white.withOpacity(0.4))),
                                                  );
                                                  Navigator.of(context).pop();
                                                  initializeData();
                                                }
                                              },
                                              checkColor: Colors.black,
                                              fillColor: MaterialStateProperty.resolveWith(
                                                      (states) => Colors.white.withOpacity(0.7)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        DateFormat('EEE, d MMM').format(DateTime.parse(snapshot.data![index]["createdAt"])) ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                        style: TextStyle(color: Colors.white,fontSize: 17),)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              snapshot.data![index]["title"] ?? "No Title",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.white,fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data![index]["description"] != null
                                              ? snapshot.data![index]["description"]
                                              : "No Description Available!",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 14),
                                    child: Row(
                                      children: [
                                        AnimatedCrossFade(
                                            firstChild: SizedBox(height: 0),
                                            secondChild: showMoreDetails(snapshot.data![index]["id"].toString(),userId!, snapshot.data![index]["title"], snapshot.data![index]["priority"], snapshot.data![index]["description"]),
                                            crossFadeState: expandedItems.contains(index) ? CrossFadeState.showSecond:CrossFadeState.showFirst,
                                            duration: Duration(milliseconds: 300)
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              if(expandedItems.contains(index)){
                                expandedItems.remove(index);
                              }
                              else{
                                expandedItems.add(index);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.redAccent.withOpacity(0.5);
      case 'medium':
        return Colors.yellowAccent.withOpacity(0.5);
      case 'low':
      default:
        return Colors.greenAccent.withOpacity(0.5);
    }
  }

  Widget showMoreDetails(String todoId, String userId, String title, String priority, String description) {
  return Container(
    child: Row(
      children: [
        GestureDetector(
          onTap: (){
            Map<String,dynamic> todoToEdit = {};
            todoToEdit["userId"] = userId;
            todoToEdit["title"] = title;
            todoToEdit["description"] = description;
            todoToEdit["priority"] = priority;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddUpdateTodosScreen(todoId: todoId, todoToEdit: todoToEdit),)
            );
          },
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.3),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Edit",style:TextStyle(color: Colors.white,fontSize: 17),),
                SizedBox(width: 10,),
                Icon(Icons.edit_note,color: Colors.white,size: 27,)
              ],
            ),
          ),
        ),
        SizedBox(width: 8,),
        GestureDetector(
          onTap: () async{
            Map<String,dynamic> userData = {};
            userData["userId"] = userId;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.4),)),
            );
            await Todo_APIService().deleteTodo(todoId, userData);
            Navigator.of(context).pop();
            Future.delayed(Durations.extralong4);
            initializeData();
          },
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Delete",style: TextStyle(color: Colors.white,fontSize: 16),),
                SizedBox(width: 10,),
                Icon(Icons.delete,color:Colors.white,size: 27,)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
