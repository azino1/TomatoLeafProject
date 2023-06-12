import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/models/user.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get mainUser => _user;

  Future<void> buildUser(Map<String, dynamic> data) async {
    _user = User.fromData(data);
    notifyListeners();
  }
}
