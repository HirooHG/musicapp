import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../modelview/music.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF1a1a1a),
        )
      )
    );
  }
}













