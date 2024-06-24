import 'package:flutter/material.dart';
import 'package:flutter_application_1/detailMember.dart';
import 'package:flutter_application_1/editMember.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/jenisTransaksi.dart';
import 'package:flutter_application_1/listMember.dart';
import 'package:flutter_application_1/listTabungan.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:flutter_application_1/registerMember.dart';
import 'package:flutter_application_1/saldoMember.dart';
import 'package:flutter_application_1/settingBunga.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:flutter_application_1/tambahSettingBunga.dart';
import 'package:flutter_application_1/tambahTabungan.dart';
import 'package:flutter_application_1/transaksiMember.dart';
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
      '/listTransaksi': (context) => TransaksiMemberPage(),
      '/detailMember': (context) => DetailMemberPage(),
      '/editMember': (context) => EditMemberPage(),
      '/addTabungan': (context) => TambahTabunganPage(),
      '/listTabungan': (context) => ListTabunganPage(),
      '/saldoMember': (context) => SaldoMemberPage(),
      '/jenisTransaksi': (context) => JenisTransaksiPage(),
      '/settingBunga': (context) => SettingBungaPage(),
      '/tambahSettingBunga': (context) => TambahSettingBungaPage(),
    },
    initialRoute: '/',
  ));
}
