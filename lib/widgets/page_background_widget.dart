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
  final Color backgroundColor;
  final String background;

  const PageBackgroundWidget({
    required this.children,
    required this.backgroundColor,
    required this.background,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              background,
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