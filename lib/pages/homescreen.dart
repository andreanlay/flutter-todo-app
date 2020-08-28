import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/model/todo_item.dart';
import 'package:test_project/pages/todo_menu.dart';
import 'package:test_project/pages/add_todo_items.dart';
import 'package:test_project/model/todo.dart';
import 'package:test_project/firebase/todo_data.dart';
import 'package:test_project/firebase/sign_in.dart';

class HomeHeader extends StatelessWidget {
  final username;

  HomeHeader(this.username);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          left: 20.0,
          top: 36.0,
        ),
        Positioned(
          child: Text(
            '$username',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          left: 20.0,
          top: 70.0,
        ),
      ],
    );
  }
}

class Homescreen extends StatefulWidget {
  final email;
  final username;

  Homescreen({Key key, @required this.email, @required this.username}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState(DatabaseService(email));
}

class _HomescreenState extends State<Homescreen> {
  final db;

  bool dataLoaded = false;
  String searchWord = '';
  List<Todo> todos = [];
  List<Todo> filteredTodo = [];
  List<Color> cardColor = [
    Colors.blue[200], Colors.green[200], Colors.red[200], 
    Colors.yellow[200], Colors.purple[200], Colors.blueGrey[200],
    Colors.deepPurple[200], Colors.teal[200]];

  _HomescreenState(this.db);

  void initState() {
    super.initState();
    if(!dataLoaded) {
      dataLoaded = true;
      loadFirestoreData();
    }
  }

  void loadFirestoreData() async {
    await db.loadTodoFromFirebase().then((value) => 
      value.docs.forEach((element) {
        todos.add(Todo(element.data()['title'], element.data()['description']));
      })
    );
    for(int i=0; i<todos.length; i++) {
      await db.getEntireTodoItems(i).then((value) => 
        value.docs.forEach((element) {
          todos[i].items.add(TodoItem(element.data()['item_name'], element.data()['done']));
        })
      );
    }
    setState((){});
  }

  Widget createTodoCard(int i) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 150,
      width: double.maxFinite,
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() => todos.removeAt(i));
        },
        child: GestureDetector(
          onLongPress: () => displayTodoMenu(context, i),
          onTap: () => displayAddItemMenu(context, i),
          child: Card(
            elevation: 5,
            color: cardColor[i % cardColor.length],
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${todos[i].title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0
                    ),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    '${todos[i].description}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0
                    )
                  )
                ],
              ),
            )
          )
        )
      )
    );
  }

  Widget loadTodo() {
    List<int> indexes = [];
    filteredTodo.clear();

    int i = 0;
    todos.forEach((element) {
      if(element.title.toLowerCase().contains(searchWord.toLowerCase())){
        filteredTodo.add(element);
        indexes.add(i);
      }
      i++;
    });

    return ListView.builder(
      itemBuilder: (context, index) {
          if(index < filteredTodo.length){
            return createTodoCard(indexes[index]);
          }
        }
    );
  }

  void displayTodoMenu(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) {
          if(index != null) {
            // Case 1: index is NOT null then we are editing a todo
            return AddTodoScreen(appBarTitle: 'Edit Todo', todoTitle: todos[index].title, description: todos[index].description, todoIndex: index,);
          }else{
            // Case 2: index is null, we are adding new todo
            return AddTodoScreen(appBarTitle: 'Add Todo');
          }
        },
        transitionsBuilder: (context, animation, secondAnimation, child) {
          final begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child
          );
        }
      ),
    );
    if(index != null) {
      todos[index].title = result.title;
      todos[index].description = result.description;
    }else{
      todos.add(result);
    }
  }

  void displayAddItemMenu(BuildContext context, int index){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoItem(todo: todos[index], index: index)
      )
    );
  }

void promptToSearchTodo() async {
    String keyword = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Keyword'),
          content: TextField(
            onChanged: (String value) => keyword = value,
            decoration: InputDecoration(hintText: 'Type something or empty to reset'),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => searchWord = keyword);
              },
              child: Text('Search')
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel')
            ),
          ],
        );
      }
    );
  }

  Widget loadingWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 30.0,
          height: 30.0,
          child: CircularProgressIndicator()
        ),
        SizedBox(width: 12),
        Text('Loading...')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Exiting App..'),
              content: Text('Do you want to exit?'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('No')
                ),
                FlatButton(
                  onPressed: () {
                    db.saveData(todos);
                    SystemNavigator.pop();
                  },
                  child: Text('Yes')
                ),
              ],
            );
          }
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => promptToSearchTodo(),  
          child: Icon(Icons.search),
          backgroundColor: Colors.lightBlue
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                bottom: PreferredSize(
                  child: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_note,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3.0,),
                        Expanded(
                          child: Text(
                            '${todos.length} To Do(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                            )
                          ),
                        ),
                        SizedBox(width: deviceWidth * 2 / 6),
                        FlatButton(
                          onPressed: () => null,
                          child: GestureDetector(
                            onTap: () => displayTodoMenu(context, null),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Add Task',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        )
                      ]
                    ),
                  ),
                  preferredSize: Size.fromHeight(50.0)
                ),
                floating: false,
                pinned: false,
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
                  child: HomeHeader(widget.username),
                )
              )
            ];
          },
          body: loadTodo()
        ),
      ),
    );
  }
}