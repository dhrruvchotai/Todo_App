import 'package:flutter/material.dart';
import 'package:todo_app/frontend/api_services/api_service.dart';

class ShowTodosScreen extends StatefulWidget {
  const ShowTodosScreen({super.key});

  @override
  State<ShowTodosScreen> createState() => _ShowTodosScreenState();
}

class _ShowTodosScreenState extends State<ShowTodosScreen> {
  APIService myAPIService = APIService();
  Future<List<Map<String, dynamic>>>? futureTodos;

  @override
  void initState() {
    super.initState();
    futureTodos = myAPIService.fetchTodos();
  }

//temporary method to check api is working or not 
  Future<void> fetchTodos() async{
    List<Map<String,dynamic>> dataList = await myAPIService.fetchTodos();
    setState(() {
      
    });
    print("Data is : ${dataList}");
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
                  "Dhruv 👋",
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.5),));
                  } else if (snapshot.hasError) {
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
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:Colors.white.withOpacity(0.3),
                          ),
                          height: 130,
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
                                    Text("82%",style: TextStyle(color: Colors.white,fontSize: 17),)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                          snapshot.data![index]["title"] ?? "No Title",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white,fontSize: 20),
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
                                )
                              ],
                            ),
                          ),
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
}
