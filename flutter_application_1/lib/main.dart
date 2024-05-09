import 'package:flutter/material.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/listMember.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:flutter_application_1/registerMember.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:flutter_application_1/welcomepage.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => WelcomePage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => SignUpPage(),
      '/homepage': (context) => HomePage(),
      '/profile': (context) => ProfilePage(),
      '/addMember': (context) => RegisterMemberPage(),
      '/listMember': (context) => MemberListPage(),
    },
    initialRoute: '/',
  ));
}
