import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreService {
  final _taskRef = FirebaseFirestore.instance.collection('tasks');

  Stream<List<TaskModel>> getTasks(String email) {
    return _taskRef
        .where('allEmails', arrayContains: email)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList());
  }

  Future<void> addTask(TaskModel task) async {
    final data = task.toMap();
    data['allEmails'] = [task.ownerEmail, ...task.sharedWith];
    await _taskRef.doc(task.id).set(data);
  }

  Future<void> updateTask(TaskModel task) async {
    final data = task.toMap();
    data['allEmails'] = [task.ownerEmail, ...task.sharedWith];
    await _taskRef.doc(task.id).update(data);
  }

  Future<void> deleteTask(String id) async {
    await _taskRef.doc(id).delete();
  }
}
