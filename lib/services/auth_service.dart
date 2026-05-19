import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResult({
    required this.success,
    required this.message,
    this.data,
  });
}

class AuthService {
  // Sign up with email
  Future<AuthResult> signUpWithEmail(String businessName, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if user already exists
      final existingUser = prefs.getString('user_email_$email');
      if (existingUser != null) {
        return AuthResult(
          success: false,
          message: 'User already exists. Please sign in.',
        );
      }
      
      // Save user data
      await prefs.setString('user_email_$email', email);
      await prefs.setString('user_name_$email', businessName);
      await prefs.setString('user_password_$email', password);
      await prefs.setString('current_user_email', email);
      await prefs.setString('current_user_name', businessName);
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('last_login', DateTime.now().toString());
      
      return AuthResult(
        success: true,
        message: 'Account created successfully!',
        data: {'email': email, 'name': businessName},
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Sign up failed: ${e.toString()}',
      );
    }
  }
  
  // Sign in with email
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final savedPassword = prefs.getString('user_password_$email');
      
      if (savedPassword == null) {
        return AuthResult(
          success: false,
          message: 'Account not found. Please sign up first.',
        );
      }
      
      if (savedPassword != password) {
        return AuthResult(
          success: false,
          message: 'Invalid password. Please try again.',
        );
      }
      
      final userName = prefs.getString('user_name_$email') ?? '';
      
      await prefs.setString('current_user_email', email);
      await prefs.setString('current_user_name', userName);
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('last_login', DateTime.now().toString());
      
      return AuthResult(
        success: true,
        message: 'Login successful!',
        data: {'email': email, 'name': userName},
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }
  
  // Sign in with Google (Demo)
  Future<AuthResult> signInWithGoogle() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      final demoEmail = 'demo.user@gmail.com';
      final demoName = 'Demo User';
      
      // Check if Google user exists
      final existingUser = prefs.getString('user_email_$demoEmail');
      if (existingUser == null) {
        await prefs.setString('user_email_$demoEmail', demoEmail);
        await prefs.setString('user_name_$demoEmail', demoName);
      }
      
      await prefs.setString('current_user_email', demoEmail);
      await prefs.setString('current_user_name', demoName);
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('login_method', 'google');
      await prefs.setString('last_login', DateTime.now().toString());
      
      return AuthResult(
        success: true,
        message: 'Google sign in successful!',
        data: {'email': demoEmail, 'name': demoName},
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Google sign in failed: ${e.toString()}',
      );
    }
  }
  
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    // Demo implementation
    await Future.delayed(const Duration(seconds: 1));
  }
  
  // Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('current_user_email');
    await prefs.remove('current_user_name');
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
  
  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user_email');
    final name = prefs.getString('current_user_name');
    
    if (email != null) {
      return {'email': email, 'name': name};
    }
    return null;
  }
}