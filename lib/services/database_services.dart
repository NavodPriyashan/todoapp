import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/model/todo_model.dart';

class DatabaseServices {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("todo");

  User? user = FirebaseAuth.instance.currentUser;

  // Add todo task
  Future<DocumentReference> addTodoTask(
      String title, String description) async {
    if (user == null) {
      throw Exception("User not logged in");
    }
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update Todo Task
  Future<void> updateTodo(String id, String title, String description) async {
    final updatetodoCollection = todoCollection.doc(id);
    return await updatetodoCollection.update({
      'title': title,
      'description': description,
    });
  }

  // Update todo status
  Future<void> updatetodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  // Delete todo task
  Future<void> deletetodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  // Get pending tasks
  Stream<List<TODO>> get todos {
    if (user == null) {
      throw Exception("User not logged in");
    }
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Get completed tasks
  Stream<List<TODO>> get completedtodos {
    if (user == null) {
      throw Exception("User not logged in");
    }
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Convert Firestore snapshot to TODO model
  List<TODO> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TODO(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        timestamp: doc['createdAt'] != null
            ? (doc['createdAt'] as Timestamp)
            : Timestamp.now(), // Fallback to current timestamp
      );
    }).toList();
  }
}
