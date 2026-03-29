import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse?> register(String email, String password,String name) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name
        }
      );
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  Future<AuthResponse?> login(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}