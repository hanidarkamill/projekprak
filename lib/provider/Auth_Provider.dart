import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek3/model/user_model.dart';
import 'package:projek3/service/encryption_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Fungsi untuk mengecek status login
  Future<bool> checkLoginStatus() async {
    final userBox = await Hive.openBox<User>('userBox');
    final username = 'user1';
    final user = userBox.get(username);
    if (user != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
    return _isLoggedIn;
  }

  // Fungsi login
  Future<bool> login(String username, String password) async {
    final userBox = await Hive.openBox<User>('userBox');
    final user = userBox.get(username);

    if (user != null &&
        EncryptionService.decryptPassword(user.password) == password) {
      _isLoggedIn = true;
      notifyListeners();
      return true; // Login sukses
    } else {
      _isLoggedIn = false;
      notifyListeners();
      return false; // Login gagal
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}
