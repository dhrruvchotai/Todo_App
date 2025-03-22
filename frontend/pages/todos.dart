import 'package:flutter/material.dart';
import 'package:todo_app/frontend/api/api_service.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
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
      appBar: AppBar(
        title: Text("TODO"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No data found!!"));
                }
            
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.blue,
                        title: Text(snapshot.data![index]["title"] ?? "No Title"),
                        subtitle: snapshot.data![index]["description"] != null
                            ? Text(snapshot.data![index]["description"])
                            : Text("No Description Available!"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
