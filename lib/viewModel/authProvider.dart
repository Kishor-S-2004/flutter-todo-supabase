import 'package:flutter/material.dart';
import 'package:todo_project/services/authServices.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  String? errorMessage;
  String? successMessage;
  bool isLoading = false;

  Future<void> register(String email, String password,String name) async {
    errorMessage = null;
    successMessage = null;

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please fill both fields';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await authService.register(email, password,name);

      if (response != null && response.user != null) {
        successMessage = 'Registration Successful!';
      } else {
        errorMessage = 'Registration failed';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email,String password)async{
      errorMessage = null;
      successMessage = null;
    if(email.isEmpty || password.isEmpty){
      errorMessage = 'Please Fill Both Fields';
      notifyListeners();
      return;
    }try{
      isLoading = true;
      notifyListeners();

      final response = await authService.login(email, password);

      if(response != null || response?.user != null){
        successMessage = 'Logged in Successfully';
        notifyListeners();
      }else{
        errorMessage = 'Login failed';
        notifyListeners();
      }
      }catch(e){
      errorMessage = e.toString();
      }finally{
      isLoading = false;
      notifyListeners();
      }
  }
}