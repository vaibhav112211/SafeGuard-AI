import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUIProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userType = ''; // 'parent' or 'child'
  String _userId = '';
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;
  String get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;

  bool get isParent => _userType == 'parent';
  bool get isChild => _userType == 'child';

  // Initialize - check saved login state
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userType = prefs.getString('userType') ?? '';
    _userId = prefs.getString('userId') ?? '';
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
  }

  // Mock login - simulates API call
  Future<bool> login(String email, String password, String type) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        return false;
      }

      if (password.length < 6) {
        return false;
      }

      // Mock successful login
      _isLoggedIn = true;
      _userType = type;
      _userId = DateTime.now().millisecondsSinceEpoch.toString();
      _userName = email.split('@')[0];
      _userEmail = email;

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', type);
      await prefs.setString('userId', _userId);
      await prefs.setString('userName', _userName);
      await prefs.setString('userEmail', _userEmail);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Mock signup
  Future<bool> signup(
      String name, String email, String password, String type) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return false;
      }

      if (password.length < 6) {
        return false;
      }

      // After signup, log them in
      return await login(email, password, type);
    } catch (e) {
      debugPrint('Signup error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _userType = '';
    _userId = '';
    _userName = '';
    _userEmail = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Switch account type (for testing)
  Future<void> switchAccountType(String type) async {
    _userType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', type);
    notifyListeners();
  }
}