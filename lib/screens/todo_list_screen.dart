// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_element

import 'package:day_10_hive_database/models/todo.dart';
import 'package:day_10_hive_database/screens/add_todo_screen.dart';
import 'package:day_10_hive_database/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoListScreen extends StatefulWidget {
  final String title;
  const TodoListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _formKey2 = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>('todo-box').listenable(),
        builder: (BuildContext context, Box<Todo> box, Widget? child) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(Strings.emptyText),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Todo? result = box.getAt(index);
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (derection) {
                  result!.delete();
                },
                background: Container(
                  color: Colors.red,
                ),
                child: Card(
                  child: ListTile(
                    title: Text(result!.title),
                    subtitle: Text(result.description),
                    trailing: SizedBox(
                      width: 100.w,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              updateTodo(context, index, result);
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await result.delete();
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Todo",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddTodoScreen(),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> updateTodo(BuildContext context, int index, Todo result) {
    return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: 250.h,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 5.w),
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      Strings.updateText,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        title = value;
                      },
                      autofocus: false,
                      decoration: InputDecoration(labelText: "title"),
                      validator: validator,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: InputDecoration(labelText: "description"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey2.currentState!.validate()) {
                          _updateInfo(index, result);
                        } else {
                          print("Form not validate");
                          return;
                        }
                      },
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Center(
                            child: Text(
                          Strings.updateButton,
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? validator(value) {
    if (value == null || value.trim().isEmpty) {
      return "required";
    } else {
      return null;
    }
  }

  _updateInfo(int index, Todo todo) {
    Box<Todo> todoBox = Hive.box<Todo>("todo-box");
    todoBox.putAt(
      index,
      Todo(title: title, description: description),
    );
    Navigator.pop(context);
    print("Info update in the box");
  }
}
