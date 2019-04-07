import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/storage/todo.dart';

class AddingTodopage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddingTodoState();
  }
  
}

class AddingTodoState extends State<AddingTodopage>{
  final _formKey =GlobalKey<FormState>();
  final addTodoController = TextEditingController();
  TodoProvider provider = TodoProvider();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Subject",
              ),
              controller: addTodoController,
              validator: (subject){
                if (subject.isEmpty){
                  return "Please fill subject";
                }
              },
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () async{
                if (_formKey.currentState.validate()) {
                  print("Pass");
                  await provider.open('todo.db');
                  await provider.insert(Todo(title : addTodoController.text));
                  Navigator.pop(context);
                }
              }
            ),
          ],
        ),
      ),
    );
  }
  
}