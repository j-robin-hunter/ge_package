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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ge_package/data/application_auth.dart';
import 'package:ge_package/presentation/reset_email_dialog.dart';
import 'package:ge_package/widgets/page_background_widget.dart';

class VerifyPage extends StatefulWidget {
  final Widget banner;
  final User user;

  const VerifyPage({
    required this.banner,
    required this.user,
    super.key,
  });

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool hover = false;

  Future<String> resetPassword(String email) async {
    String action = await ApplicationAuth().updateEmailAndVerify(widget.user, email);
    return action;
  }

  @override
  Widget build(BuildContext context) => Material(
    child: PageBackgroundWidget(
      backgroundColor: const Color(0xff2a2a2a),
      background: 'assets/earth.webp',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.banner,
                  const SizedBox(height: 20),
                  const Text(
                    "Verify your email",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You have recently been sent an email link to ${widget.user.email} that will allow you to verify your email address and activate your account",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Click here",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: !hover ? FontWeight.normal : FontWeight.w900,
                          ),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => ResetEmailDialog(email: widget.user.email, resetEmail: resetPassword),
                              ).then((reset) {
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
                                      'Email reset',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    content: Container(
                                      color: Colors.white,
                                      width: 400,
                                      child: Text(reset),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, null),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          onEnter: (_) => setState(() => hover = true),
                          onExit: (_) => setState(() => hover = false),
                        ),
                        const TextSpan(text: " "),
                        const TextSpan(
                          text: "if you did not receive the email or would like to change the email address you signed up with",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        await ApplicationAuth().logout();
                        if (!context.mounted) return;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'OK',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}