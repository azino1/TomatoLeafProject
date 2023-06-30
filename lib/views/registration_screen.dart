import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tomato_leave_virus_mobile/helpers/firebase_service.dart';
import 'package:tomato_leave_virus_mobile/providers/user_provider.dart';
import 'package:tomato_leave_virus_mobile/views/Login_screen.dart';

import '../constant.dart';
import 'menu_screen.dart';

///Registration Screen
class RegistrationScreen extends ConsumerStatefulWidget {
  static const routeName = "/registration";
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  /// Holds the firstName enter the user
  TextEditingController _firstNameController = TextEditingController();

  /// Holds the lasttName entered the user
  TextEditingController _lastNameController = TextEditingController();

  /// Holds the email entered by user
  TextEditingController _emailController = TextEditingController();

  ///Holds the phone number enterred by user
  TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isregistering = false;

  /// register user by adding thier details to the firestore user collection
  ///
  /// Email address of the user is not mandatory
  void registerUser() async {
    // _formKey.currentState.validate() to ensure the form field validator is called
    final formValidate = _formKey.currentState?.validate();

    //this ensure the code below it in the method is not run
    if (!formValidate!) return;

    _formKey.currentState?.save();

    setState(() {
      isregistering = true;
    });

    try {
      final userData = await FirebaseServices().registerUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
          userEmail: _emailController.text);

      await ref.read(userProvider).buildUser(userData);
      if (!mounted) return;
      context.go(NewCaptureScreen.routeName);
    } catch (e) {
      print(e);
      errorUpMessage(context, e.toString(), "Registration Error");
    }

    setState(() {
      isregistering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Holds the device size
    final deviceSize = MediaQuery.of(context).size;

    /// Holds the primary theme color of this app
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
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
                        onTap: () => context.go(LoginScreen.routeName),
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
                    validator: (val) {
                      if (val != null && val.number.length < 11) {
                        return "please your number must be 11 digits";
                      }

                      if (val != null && val.number[0] != "0") {
                        return "your number is invalid";
                      }

                      return null;
                    },
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
                  isregistering
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
                          //sends the user to the login screen
                          onTap: registerUser,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: primaryColor),
                            child: const Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () => context.push(LoginScreen.routeName),
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Already Have an Account? ",
                            style: TextStyle(color: greyText, fontSize: 12)),
                        TextSpan(
                            text: "Login",
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
      ),
    );
  }

  /// An inputbox widget where a user can input his/her details.
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
              if (isEmail == true && value != null) {
                return null;
              }
              if (isEmail && value != null && !value.contains("@")) {
                return "provide a valid email";
              }
              if (value != null && value.isEmpty) {
                return "Field is required";
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
