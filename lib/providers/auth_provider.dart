import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _hasOnboarded = false;

  bool get isLoggedIn => _supabase.auth.currentSession != null;
  bool get hasOnboarded => _hasOnboarded;

  AuthProvider() {
    _supabase.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signup(String name, String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    reset();
  }

  void completeOnboarding() {
    _hasOnboarded = true;
    notifyListeners();
  }

  void reset() {
    _hasOnboarded = false;
    notifyListeners();
  }
}