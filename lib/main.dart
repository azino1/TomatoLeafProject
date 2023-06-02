import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/views/Login_screen.dart';
import 'package:tomato_leave_virus_mobile/views/registration_screen.dart';

import 'views/menu_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primaryColor: const Color.fromRGBO(5, 10, 27, 1),
              fontFamily: "LeagueSpartan")
          .copyWith(
        scaffoldBackgroundColor: const Color(0XffFFFFFF),
      ),
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: RegistrationScreen.routeName,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: NewCaptureScreen.routeName,
        builder: (context, state) => const NewCaptureScreen(),
      ),
    ],
  );
}
