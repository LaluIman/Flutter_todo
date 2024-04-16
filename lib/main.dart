import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = []; // nampung data

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title, completed: false));
    });
  }

  void toggleTaskCompleted(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type new To Do",
                ),
                onSubmitted: (title) => addTask(title),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
             
                ),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0), // Adjust as desired
                            color: Colors.grey[200], // Adjust as desired
                          ),
                          child: Row( // Wrap icon and title in a Row
                            children: [
                              Checkbox(
                                value: tasks[index].completed,
                                onChanged: (_) => toggleTaskCompleted(index),
                              ),
                              Text(tasks[index].title),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTask(index),
                        ),
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
}
