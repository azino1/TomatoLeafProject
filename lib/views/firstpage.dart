import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/providers/user_provider.dart';
import 'package:tomato_leave_virus_mobile/views/Login_screen.dart';
import 'package:tomato_leave_virus_mobile/views/menu_screen.dart';

class FirstPage extends ConsumerStatefulWidget {
  const FirstPage({super.key});

  @override
  ConsumerState<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage> {
  ///Loads the login status of the current user
  late Future<bool> loginStatus;

  @override
  void initState() {
    loginStatus = ref.read(userProvider).onDeviceLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: FutureBuilder(
        future: loginStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: primaryColor,
                ),
              ),
            );
          }
          if (snapshot.data == true) {
            return NewCaptureScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
