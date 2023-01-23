import 'dart:io';

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(

      )
    );
  }
}
