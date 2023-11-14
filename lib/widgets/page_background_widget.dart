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

import 'package:flutter/material.dart';

class PageBackgroundWidget extends StatelessWidget {
  final List<Widget> children;

  const PageBackgroundWidget({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2a2a2a),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/earth.webp',
              width: double.infinity,
              //height: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        ] +
            children,
      ),
    );
  }
}