import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/models/user.dart' as model;
import 'package:flutter_application_1/services/user_service.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final UserMethods _userMethods = UserMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    model.User? user = await _userMethods.getUserDetails();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}
