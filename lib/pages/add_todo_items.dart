import 'package:flutter/material.dart';
import 'package:test_project/model/todo.dart';
import 'package:test_project/model/todo_item.dart';

class AddTodoItem extends StatefulWidget {
  Todo todo;
  int index;

  AddTodoItem({Key key, @required this.todo, @required this.index}) : super(key: key);

  @override
  _AddTodoItemState createState() => _AddTodoItemState();
}

class _AddTodoItemState extends State<AddTodoItem> {

  void promptToAddItem() async {
    String itemName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Item'),
          content: TextField(
            onChanged: (String value) => itemName = value,
            decoration: InputDecoration(hintText: 'Item name'),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel')
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  widget.todo.items.add(TodoItem(itemName, false));
                });
              },
              child: Text('Save')
            ),
          ],
        );
      }
    );
  }

  Widget buildItemRow(int index){
    bool done = widget.todo.items[index].done;
    return Row(
      children: [
        Checkbox(
          value: done ? true : false,
          onChanged: (state) {
            setState(() {
              widget.todo.isDone += (done ? -1 : 1);
              widget.todo.items[index].done = !done;
              done = !done;
            });
          }
        ),
        Text(
          '${widget.todo.items[index].itemName}',
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : TextDecoration.none
          )
        )
      ],
    );
  }

  Widget buildTodoItems(){
    return ListView.builder(
      itemBuilder: (context, index) {
        if(index < widget.todo.items.length){
          return buildItemRow(index);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.todo.title}'),
          centerTitle: true,
          leading: Container(),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => Navigator.pop(context),
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue,
                  Colors.white38
                ]
              )
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => promptToAddItem(),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.todo.description}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0
                )
              ),
              SizedBox(height: 22.0),
              Padding(
                padding: EdgeInsets.only(left: deviceWidth - 195.0),
                child: Text(
                  '${widget.todo.isDone} out of ${widget.todo.items.length} is completed.',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Divider(thickness: 2.0, height: 20,),
              Center(
                child: Text(
                  'Task List',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0
                  )
                )
              ),
              Expanded(
                child: buildTodoItems()
              ),
            ]
          ),
        ),
      )
    );
  }
}