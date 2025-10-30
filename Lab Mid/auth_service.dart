import 'package:flutter/foundation.dart';
import 'database_service.dart';

class AuthService extends ChangeNotifier {
  bool _isSignedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  final DatabaseService _dbService = DatabaseService();

  bool get isSignedIn => _isSignedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ Admin Login Function (Simple username/password)
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // ✅ Check credentials from database or fallback to hardcoded credentials
    final isValid = await _dbService.verifyAdminLogin(username, password);

    if (isValid) {
      _isSignedIn = true;
    } else {
      _errorMessage = "⚠️ Wrong username / password! (Hint: rafia / rafia123)";
      _isSignedIn = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  // ✅ Logout function
  void logout() {
    _isSignedIn = false;
    notifyListeners();
  }
}
