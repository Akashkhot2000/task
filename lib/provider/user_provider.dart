import 'package:flutter/material.dart';
import 'package:task/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get user => _userModel;

  void setUser(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  void addUsers(List<Data> newData) {
    if (_userModel != null) {
      _userModel!.data ??= [];
      _userModel!.data!.addAll(newData);
      notifyListeners();
    }
  }
}
