import 'package:faskes/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = UserModel();
    notifyListeners();
  }

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }
}
