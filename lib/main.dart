import 'package:flutter/material.dart';
import 'package:nueraTalk/routes/routes.dart';
import 'package:nueraTalk/routes/routes_name.dart';
import 'package:nueraTalk/utils/app_colors.dart';

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
