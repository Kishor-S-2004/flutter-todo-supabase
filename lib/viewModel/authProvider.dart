import 'package:flutter/material.dart';
import 'package:todo_project/services/authServices.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  String? errorMessage;
  String? successMessage;
  bool isLoading = false;

  Future<bool> register(String email, String password,String name) async {
    errorMessage = null;
    successMessage = null;

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please fill all fields';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await authService.register(email, password,name);

      if (response != null && response.user != null) {
        successMessage = 'Registration Successful!';
      return true;
      } else {
        errorMessage = 'Registration failed';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email,String password)async{
      errorMessage = null;
      successMessage = null;
    if(email.isEmpty || password.isEmpty){
      errorMessage = 'Please Fill Both Fields';
      notifyListeners();
      return false;
    }try{
      isLoading = true;
      notifyListeners();

      final response = await authService.login(email, password);

      if(response != null || response?.user != null){
        successMessage = 'Logged in Successfully';
        notifyListeners();
        return true;
      }else{
        errorMessage = 'Login failed';
        notifyListeners();
        return false;
      }
      }catch(e){
      errorMessage = e.toString();
      return false;
      }finally{
      isLoading = false;
      notifyListeners();
      }
  }

  Future<void> logout() async {
    await authService.logout();
  }
}