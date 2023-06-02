import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tomato_leave_virus_mobile/views/Login_screen.dart';

import '../constant.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registration";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(241, 245, 249, 1)),
                  child: Icon(
                    Icons.close,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Registration",
                  style: TextStyle(
                      fontSize: 34,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "League Spartan"),
                ),
                const SizedBox(height: 5),
                const Text("Fill the fields below to get started.",
                    style: TextStyle(
                        color: hightLightTextColor,
                        fontFamily: "League Spartan")),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                inputBox('First Name', _firstNameController, "eg. John"),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                inputBox('Last Name', _lastNameController, "eg. Peter"),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                inputBox(
                    'Email Address', _emailController, "eg. user@domain.com",
                    isEmail: true),
                SizedBox(
                  height: deviceSize.height * 0.03,
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
                  onTap: () => context.push(LoginScreen.routeName),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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

  Widget inputBox(
      String label, TextEditingController _controller, String hintText,
      {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: textFieldColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: textFieldColor),
                    borderRadius: BorderRadius.circular(10)),
                hintText: hintText,
                hintStyle: const TextStyle(color: hintTextColor)),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                return "Field is required";
              }
              if (isEmail && value != null && !value.contains("@")) {
                return "provide a valid email";
              }
              return null;
            },
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
          ),
        )
      ],
    );
  }
}
