import 'package:chatbot/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyBGColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.themeColor,
        title: const Text(
          "NeuraTalk",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: AppColor.themeTextColor,
              ),
        ),
      ),
    );
  }
}
