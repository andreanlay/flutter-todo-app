import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_project/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final String userId;

  DatabaseService(this.userId);

  Future<QuerySnapshot> loadTodoFromFirebase() {
    final docs = database.collection('users').doc(userId)
                        .collection('todo').get();
    return docs;
  }

  Future<QuerySnapshot> getEntireTodoItems(int index) {
    final docs = database.collection('users').doc(userId)
                      .collection('todo').doc('todo$index')
                      .collection('item').get();
    return docs;
  }

  void deleteAllData() {
    print('called');
    final path = database.collection('users').doc(userId);
    path.collection('todo').get().then((docs) {
      docs.docs.forEach((element) {
        element.reference.collection('item').get().then((value) => 
          value.docs.forEach((element) {
            element.reference.delete();
          })
        );
        element.reference.delete();
      });
    });
  }

  void saveData(List<Todo> todos) {
    final path = database.collection('users').doc(userId);

    path.update({
      'todo_count': todos.length
    });

    for(int i=0; i<todos.length; i++) {
      path.collection('todo').doc('todo$i').set({
        'title': todos[i].title,
        'description': todos[i].description,
        'items': todos[i].items.length,
        'items_done': todos[i].isDone,
      });
      
      for(int j=0; j<todos[i].items.length; j++) {
        path.collection('todo').doc('todo$i')
            .collection('item').doc('item$j').set({
              'item_name': todos[i].items[j].itemName,
              'done': todos[i].items[j].done,
            });
      }
    }
  }
}