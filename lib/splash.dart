import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../menu.dart';

import '../menu.dart';
import 'auth/Login.dart';
import 'auth/firstpage.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final mail = prefs.getString('email');

    if (token != null) {
      Get.to(()=>Menu(mail: mail,token: token,),transition: Transition.rightToLeft);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => First(),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      _checkToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('images/tt.gif'),
      ),
    );
  }

}
