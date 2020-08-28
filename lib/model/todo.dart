import 'package:test_project/model/todo_item.dart';

class Todo{
  String title;
  String description;
  List<TodoItem> items;
  int isDone = 0;

  Todo(this.title, this.description){
    this.items = [];
    isDone = 0;
  }
}