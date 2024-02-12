
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/widgets/rounded_btn.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Todo(),
  ));
}

class Todo extends StatefulWidget {
  const Todo({Key? key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<Task> tasks = [];
  TextEditingController adddata = TextEditingController();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs!.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks
            .asMap()
            .map((index, title) => MapEntry(
            index, Task(index, title, prefs!.getBool('task$index') ?? false)))
            .values
            .toList();
      });
    }
  }

  saveTasks() async {
    List<String> taskString = tasks.map((task) => task.title).toList();
    await prefs!.setStringList('tasks', taskString);
    tasks.forEach((task) async {
      await prefs!.setBool('task${task.id}', task.isCompleted);
    });
  }

  addTask() {
    String newTaskTitle = adddata.text.trim();
    if (newTaskTitle.isNotEmpty) {
      setState(() {
        tasks.add(Task(tasks.length, newTaskTitle, false));
      });
      saveTasks();
      adddata.clear();
    }
  }

  _updateTaskCompletion(int index, bool value) {
    setState(() {
      tasks[index].isCompleted = value;
    });
    prefs!.setBool('task$index', value);
  }

  @override
  Widget build(BuildContext context) {
    tasks.sort((a, b) => a.title.compareTo(b.title));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.black,)),
            child: TextField(
              decoration: InputDecoration(hintText: "Enter Data"),
              controller: adddata,
            ),
          ),
          Container(
            height: 50,
            width: 120,
            child: RoundedButton(
              backgroundcolor: Colors.blue,
              buttonName: 'Add Task',
              callback: addTask,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) {
                      _updateTaskCompletion(index, value ?? false);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                      saveTasks();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Task {
  int id;
  String title;
  bool isCompleted;

  Task(this.id, this.title, this.isCompleted);
}
