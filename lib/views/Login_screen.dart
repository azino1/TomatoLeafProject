import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tomato_leave_virus_mobile/helpers/firebase_service.dart';
import 'package:tomato_leave_virus_mobile/providers/user_provider.dart';
import 'package:tomato_leave_virus_mobile/views/menu_screen.dart';
import 'package:tomato_leave_virus_mobile/views/registration_screen.dart';

import '../constant.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  ///Holds the user phone number inputs.
  TextEditingController _phoneController = TextEditingController();

  bool isLogin = false;

  void logInUser() async {
    if (_phoneController.text.isEmpty) {
      errorUpMessage(context, "please login with your phone number", 'Error');
      return;
    }

    if (_phoneController.text.length != 11) {
      errorUpMessage(context, "phone number is invalid", 'Error');
      return;
    }

    setState(() {
      isLogin = true;
    });

    try {
      final userData =
          await FirebaseServices().loginUser(_phoneController.text);
      ref.read(userProvider).buildUser(userData);
      if (!mounted) return;
      context.go(NewCaptureScreen.routeName);
    } catch (e) {
      print(e);
      errorUpMessage(context, e.toString(), "Error");
    }

    setState(() {
      isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      //allows the user to close the keyboard.
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: deviceSize.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      //takes the user to the previous screen
                      onTap: () => context.go(RegistrationScreen.routeName),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(241, 245, 249, 1)),
                        child: Icon(
                          Icons.close,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          context.go(NewCaptureScreen.routeName);
                        },
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                              fontSize: 18,
                              color: primaryColor,
                              fontFamily: "LeagueSpartan"),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 34,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "League Spartan"),
                ),
                const SizedBox(height: 5),
                const Text("Fill the fields below to get access.",
                    style: TextStyle(
                        color: hightLightTextColor,
                        fontFamily: "League Spartan")),
                SizedBox(
                  height: deviceSize.height * 0.05,
                ),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: textFieldColor),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: textFieldColor),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  initialCountryCode: 'NG',
                  showCountryFlag: false,
                  onCountryChanged: (value) {
                    print(value.code);
                  },
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                isLogin
                    ? Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: primaryColor,
                          ),
                        ),
                      )
                    : InkWell(
                        //sends the user to Homescreen where he can make a new capture.
                        onTap: logInUser,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: primaryColor),
                          child: const Center(
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: InkWell(
                    onTap: () => context.push(RegistrationScreen.routeName),
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: "I don’t have an account? ",
                          style: TextStyle(color: greyText, fontSize: 12)),
                      TextSpan(
                          text: "Register",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ])),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
