// ************************************************************
//
// Copyright 2024 Robin Hunter rhunter@crml.com
// All rights reserved
//
// This work must not be copied, used or derived from either
// or via any medium without the express written permission
// and license from the owner
//
// ************************************************************
library ge_package;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../data/application_auth.dart';
import '../widgets/page_background_widget.dart';
import 'password_reset_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String action = 'login';
  bool isObscured = true;
  String? errorMessage;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String?> login(String email, String password) async {
    return ApplicationAuth().loginWithEmailAndPassword(email, password);
  }

  Future<String?> register(String email, String password) async {
    return ApplicationAuth().register(email, password);
  }

  Future<void> resetPassword(String password) async {
    ApplicationAuth().resetPassword(password);
  }

  @override
  Widget build(BuildContext context) => Material(
    child: PageBackgroundWidget(
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              padding: const EdgeInsets.all(20),
              width: 400,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text(
                          'DEVELOPER API CONSOLE',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'GREENER ENERGY',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            letterSpacing: 1.8,
                            color: Color(0xff4a6741),
                          ),
                        ),
                        Text(
                          'FLOW MODEL',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Color(0xff4a6741),
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (email) => EmailValidator.validate(email!) ? null : 'Valid user email required',
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'User*',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.length < 8) return 'Minimum 8 characters';
                        RegExp regex = RegExp(r'.*[a-z]');
                        if (!regex.hasMatch(value)) return 'Lowercase character required';
                        regex = RegExp(r'.*[A-Z]');
                        if (!regex.hasMatch(value)) return 'Uppercase character required';
                        regex = RegExp(r'.*\d');
                        if (!regex.hasMatch(value)) return 'Number character required';
                        regex = RegExp(r'.*[@$!%*?&]');
                        if (!regex.hasMatch(value)) return 'Special character required (@\$!%*?&)';
                        return null;
                      },
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Password*',
                        suffixIcon: IconButton(
                          icon: isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          onPressed: () => setState(() => isObscured = !isObscured),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: isObscured,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final String? err;
                          if (action == 'login') {
                            err = await login(emailController.text.trim(), passwordController.text.trim());
                          } else {
                            err = await register(emailController.text.trim(), passwordController.text.trim());
                          }
                          setState(() => errorMessage = err);
                        }
                      },
                      child: Text(
                        action.toUpperCase(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    errorMessage == null
                        ? const SizedBox(height: 15)
                        : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    action == 'login'
                        ? Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => ResetPasswordDialog(resetPassword: resetPassword),
                          ).then(
                                (reset) {
                              if (reset) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    title: const Text(
                                      'Password reset',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    content: Container(
                                      color: Colors.white,
                                      child: const Text('Please check your email for a password reset link'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, null),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          child: const Text(
                            'RESET PASSWORD',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(width: double.infinity),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            emailController.text = '';
                            passwordController.text = '';
                            action = 'register';
                            errorMessage = null;
                          }),
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    )
                        : Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() {
                          emailController.text = '';
                          passwordController.text = '';
                          action = 'login';
                          errorMessage = null;
                        }),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}