import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../viewmodel/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 7.h, color: theme.primaryColor),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16.sp),
                      prefixIcon: Icon(Icons.email_outlined, size: 22.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16.sp),
                      prefixIcon: Icon(Icons.lock_outline, size: 22.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login, size: 20.sp),
                      label: Text(
                        "Login",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      onPressed: () async {
                        final email = emailCtrl.text.trim();
                        final password = passCtrl.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in all fields')),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          await authVM.login(email, password, context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
