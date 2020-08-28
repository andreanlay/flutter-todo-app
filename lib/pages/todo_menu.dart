import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/model/todo.dart';

class AddTodoScreen extends StatelessWidget {
  String appBarTitle;
  String todoTitle = '';
  String description = '';
  int todoIndex;

  AddTodoScreen({Key key, @required this.appBarTitle, this.todoTitle, this.description, this.todoIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: Container(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue,
                Colors.white38,
              ]
            )
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (String value) => this.todoTitle = value,
              initialValue: this.todoTitle,
              inputFormatters: [
                LengthLimitingTextInputFormatter(25),
              ],
              decoration: InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (String value) => this.description = value,
              initialValue: this.description,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],  
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth - 125, top: 10.0),
              child: RaisedButton(
                onPressed: () => Navigator.pop(context, Todo(this.todoTitle, this.description)),
                child: Text('Save'),
                color: Colors.lightBlue,
              )
            )
          ],
        )
      ),
    );
  }
}