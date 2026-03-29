import 'package:flutter/material.dart';
import 'package:todo_project/view/screens/auth/loginScreen.dart';
import 'package:todo_project/view/widget/authWidgets.dart';
import 'package:todo_project/viewModel/authProvider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // title: const Text('Register'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Sign up to get started",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 30),

                // Email
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  icon: Icons.person,
                ),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                ),

                // Password
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: isPasswordObscure,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordObscure = !isPasswordObscure;
                      });
                    },
                    icon: Icon(
                      isPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isPasswordObscure ? Colors.black : Colors.green,
                    ),
                  ),
                ),

                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock,
                  obscureText: isConfirmPasswordObscure,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordObscure = !isConfirmPasswordObscure;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,color: isConfirmPasswordObscure ? Colors.black : Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Button
                SubmitButton(
                  text: 'Sign Up',
                  isLoading: provider.isLoading,
                  onTap: provider.isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final confirmPassword = _confirmPasswordController.text.trim();
                          final name = _nameController.text.trim();

                          if(password != confirmPassword){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password doesn't match")));
                            return;
                          }

                          final vm = context.read<AuthProvider>();
                          await vm.register(email, password,name);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

                          _emailController.clear();
                          _nameController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();

                          if (vm.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(vm.errorMessage!)),
                            );
                          }
                        },
                ),

                const SizedBox(height: 20),

                // Bottom text
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
