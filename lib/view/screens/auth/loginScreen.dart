import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/view/screens/auth/registerScreen.dart';
import 'package:todo_project/view/screens/home/todoHomeScreen.dart';
import 'package:todo_project/view/widget/authWidgets.dart';
import 'package:todo_project/viewModel/authProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Hello User",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Sign in and create todo",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.mail,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.password,
                  obscureText: isObscure,
                  suffixIcon: IconButton(onPressed:() {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },icon:Icon(isObscure ? Icons.visibility_off : Icons.visibility,color: isObscure ? Colors.black : Colors.green,)),
                ),

                SubmitButton(
                  text: 'Sign In',
                  onTap: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if(email.isEmpty || password.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill both fields')));
                      return;
                    }

                    final vm = context.read<AuthProvider>();
                    await vm.login(email, password);

                    if (vm.errorMessage == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );

                      _emailController.clear();
                      _passwordController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(vm.errorMessage!)),
                      );
                    }

                    _emailController.clear();
                    _passwordController.clear();

                    if (vm.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(vm.errorMessage!)),
                      );
                    }
                  },
                  isLoading: provider.isLoading,
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>RegisterScreen(),));
                    },
                    child: Text(
                      "Doesn't have an Account? Sign Up",
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
