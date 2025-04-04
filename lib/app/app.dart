import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../features/tasks/view/login_screen.dart';
import '../features/tasks/view/task_screen.dart';
import '../features/tasks/viewmodel/auth_view_model.dart';
import '../features/tasks/viewmodel/task_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ],
        child: MaterialApp(
          title: 'TODO App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/tasks': (context) {
              final userEmail = Provider.of<AuthViewModel>(context).currentUser?.email ?? '';
              return TaskScreen();
            },
          },
        ),
      ),
    );
  }
}
