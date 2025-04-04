import 'package:flutter/cupertino.dart';

import '../../../core/models/task_model.dart';
import '../../../core/services/firestore_service.dart';

class TaskViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<TaskModel>> getTasks(String email) {
    return _firestoreService.getTasks(email);
  }

  Future<void> addTask(TaskModel task) async {
    await _firestoreService.addTask(task);
  }

  Future<void> updateTask(TaskModel updatedTask, String currentUserEmail) async {
    final existingTasks = await _firestoreService.getTasks(currentUserEmail).first;
    final existing = existingTasks.firstWhere((t) => t.id == updatedTask.id, orElse: () => updatedTask);

    final newTask = updatedTask.copyWith(
      isDone: updatedTask.isDone,
    );

    await _firestoreService.updateTask(newTask);
  }

  Future<void> toggleTaskDone(TaskModel task, bool isDone) async {
    final updated = task.copyWith(isDone: isDone);
    await _firestoreService.updateTask(updated);
  }

  Future<void> deleteTask(String id) async {
    await _firestoreService.deleteTask(id);
  }
}
