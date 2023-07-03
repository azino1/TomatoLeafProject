import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:tomato_leave_virus_mobile/models/user.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get mainUser => _user;

  Future<void> buildUser(Map<String, dynamic> data) async {
    _user = User.fromData(data);

    notifyListeners();
    if (_user == null) return;
    final pref = await SharedPreferences.getInstance();
    final userLoginData = json.encode({
      "id": _user?.userId,
      "email": _user?.email,
      "firstName": _user?.firstName,
      "lastName": _user?.lastName,
      "phone": _user?.phone,
    });
    pref.setString("loginData", userLoginData);
  }

  /// Check user details saved locally and login user with it
  Future<bool> onDeviceLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("loginData")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString("loginData")!) as Map<String, dynamic>;

    try {
      _user = User.fromData(extractedUserData);
    } catch (e) {
      _user = null;
      return false;
    }

    notifyListeners();
    return true;
  }

  ///This function logout a user.
  ///
  ///It changes the user object to null and remove the login data saved on temp storage.
  ///Anyone who call this function is expected to route the user back to the login screen.
  Future<void> logoutUser() async {
    _user = null;
    try {
      final pref =
          await SharedPreferences.getInstance(); //Obtain shared preferences.
      pref.remove("loginData");
    } catch (e) {}
    notifyListeners();
  }
}
