import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tomato_leave_virus_mobile/views/menu_screen.dart';

import '../constant.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///Holds the user phone number inputs.
  TextEditingController _phoneController = TextEditingController();

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
                InkWell(
                  //takes the user to the previous screen
                  onTap: () => context.pop(),
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
                InkWell(
                  //sends the user to Homescreen where he can make a new capture.
                  onTap: () => context.push(NewCaptureScreen.routeName),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
