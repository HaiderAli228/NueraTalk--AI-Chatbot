import 'package:chatbot/routes/routes.dart';
import 'package:chatbot/routes/routes_name.dart';
import 'package:chatbot/utils/app_colors.dart';
import 'package:chatbot/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primaryColor: AppColor.themeColor,
      ),
      initialRoute: RoutesName.homeView,
      onGenerateRoute: Routes.generatedRoutes,
    );
  }
}
