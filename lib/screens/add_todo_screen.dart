// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:day_10_hive_database/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import '../models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;

  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmitt();
      print("Form validate");
    } else {
      print("Form not validate");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15,
              top: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    title = value;
                  },
                  autofocus: false,
                  decoration: InputDecoration(labelText: "title"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "required";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.done,
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
                SizedBox(height: 14.h,),
                InkWell(
                  onTap: () => validated(),
                  child: Center(
                    child: Container(
                      height: 35.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12.r)
                      ),
                      child: Center(child: Text(Strings.addTodoButton,style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.w600),)),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onFormSubmitt() {
    Box<Todo> todoBox = Hive.box<Todo>('todo-box');
    todoBox.add(Todo(title: title, description: description));
    Navigator.pop(context);
  }
}
