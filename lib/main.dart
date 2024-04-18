import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = Task.tasksFromJson(_prefs.getStringList('tasks') ?? []);
    });
  }

  _saveTasks() {
  List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
  _prefs.setStringList('tasks', tasksJson);
}


  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title, completed: false));
      _saveTasks();
    });
  }

  void toggleTaskCompleted(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      _saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), 
                border: Border.all(color: Colors.black), 
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type new task...",
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                ),
                onSubmitted: (title) => addTask(title),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: tasks[index].completed,
                              onChanged: (_) => toggleTaskCompleted(index),
                            ),
                            Text(tasks[index].title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black),),
                          ],
                        ),
                      ),
                      trailing: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.red, 
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.white,
                              onPressed: () => deleteTask(index),
                            ),
                      )
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  bool completed;

  Task({required this.title, this.completed = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  static List<Task> tasksFromJson(List<String> jsonList) {
    return jsonList.map((json) {
      Map<String, dynamic> map = jsonDecode(json);
      return Task(
        title: map['title'],
        completed: map['completed'],
      );
    }).toList();
  }
}