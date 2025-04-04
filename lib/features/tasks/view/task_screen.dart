import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/models/task_model.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/task_view_model.dart';
import 'edit_task_dialog.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final userEmail = authVM.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text("Hello, $userEmail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => authVM.logout(context),
          )
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: taskVM.getTasks(userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(
              child: Text("No tasks available", style: TextStyle(fontSize: 17.sp)),
            );
          }

          final isTabletOrDesktop = Device.screenType != ScreenType.mobile;
          final crossAxisCount = Device.screenType == ScreenType.desktop ? 3 : 2;

          return isTabletOrDesktop
              ? buildTaskGrid(tasks, userEmail, context, crossAxisCount)
              : buildTaskList(tasks, userEmail, context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(context: context, builder: (_) => const EditTaskDialog());
        },
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
      ),
    );
  }

  // Mobile layout
  Widget buildTaskList(List<TaskModel> tasks, String userEmail, BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isOwner = task.ownerEmail == userEmail;
        return buildTaskCard(task, isOwner, context);
      },
    );
  }

  // Grid layout for larger screens
  Widget buildTaskGrid(List<TaskModel> tasks, String userEmail, BuildContext context, int crossAxisCount) {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: tasks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isOwner = task.ownerEmail == userEmail;
        return buildTaskCard(task, isOwner, context);
      },
    );
  }

  // Modern card UI
  Widget buildTaskCard(TaskModel task, bool isOwner, BuildContext context) {
    final createdDate = DateFormat('dd MMM yyyy hh:mm a').format(task.createdAt);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      shadowColor: Colors.grey.withOpacity(0.3),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Edit Task',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditTaskDialog(task: task),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 0.8.h),
            Text(task.description, style: TextStyle(fontSize: 15.sp, color: Colors.black87)),
            SizedBox(height: 1.h),
            Text("🕒 Created: $createdDate", style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                const Icon(Icons.group_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    isOwner
                        ? "Shared with: ${task.sharedWith.join(', ')}"
                        : "Shared by: ${task.ownerEmail}",
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
