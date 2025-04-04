import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/models/task_model.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/task_view_model.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskModel? task;
  const EditTaskDialog({super.key, this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _shareController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> sharedEmails = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      sharedEmails = List.from(widget.task!.sharedWith);
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final userEmail = authVM.currentUser!.email!;
    final now = DateTime.now();

    setState(() => _isLoading = true);

    final task = TaskModel(
      id: widget.task?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      ownerEmail: widget.task?.ownerEmail ?? userEmail,
      sharedWith: widget.task == null || widget.task?.ownerEmail == userEmail
          ? sharedEmails
          : widget.task!.sharedWith,
      createdAt: widget.task?.createdAt ?? now,
      isDone: widget.task?.isDone ?? false, // ✅ Added line
    );

    try {
      if (widget.task != null) {
        await taskVM.updateTask(task, userEmail);
      } else {
        await taskVM.addTask(task);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final userEmail = authVM.currentUser?.email;
    final isEditing = widget.task != null;
    final isOwner = widget.task?.ownerEmail == userEmail || widget.task == null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                isEditing ? 'Edit Task' : 'New Task',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 1.5.h),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Description is required' : null,
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _shareController,
                      enabled: isOwner,
                      decoration: InputDecoration(
                        labelText: 'Share with email',
                        prefixIcon: const Icon(Icons.alternate_email_outlined),
                        filled: !isOwner,
                        fillColor: isOwner ? null : Colors.grey.shade200,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 6.w),
                    tooltip: 'Add email',
                    onPressed: isOwner
                        ? () {
                      final trimmed = _shareController.text.trim();
                      if (trimmed.isNotEmpty && !sharedEmails.contains(trimmed)) {
                        setState(() {
                          sharedEmails.add(trimmed);
                          _shareController.clear();
                        });
                      }
                    }
                        : null,
                  ),
                ],
              ),

              if (!isOwner)
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Only the owner can edit the shared email list.',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                  ),
                ),

              if (sharedEmails.isNotEmpty) ...[
                SizedBox(height: 1.5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 1.w,
                    runSpacing: 1.h,
                    children: sharedEmails
                        .map(
                          (email) => Chip(
                        label: Text(email, style: TextStyle(fontSize: 15.sp)),
                        deleteIcon: Icon(Icons.close, size: 16.sp),
                        onDeleted: isOwner
                            ? () {
                          setState(() {
                            sharedEmails.remove(email);
                          });
                        }
                            : null,
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],

              SizedBox(height: 3.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
                  ),
                  SizedBox(width: 2.w),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon: Icon(isEditing ? Icons.save_outlined : Icons.add, size: 18.sp),
                    label: Text(isEditing ? 'Update' : 'Add', style: TextStyle(fontSize: 16.sp)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading) ...[
                SizedBox(height: 2.h),
                const CircularProgressIndicator(),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
