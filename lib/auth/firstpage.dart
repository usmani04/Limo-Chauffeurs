import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../extra/videoplayer.dart';
import '../menu.dart';
import '../token/token.dart';
import 'Login.dart';
import 'otp.dart';
class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
      return false;
    } else {
      // Permission denied
      return false;
    }
  }
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
      return false;
    } else {
      // Permission denied
      return false;
    }
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    requestNotificationPermission();
  }
  bool _saveToken = false;
  bool _obscureText = true;
  String? tt;
  TextEditingController email = TextEditingController();
  submitData(String e) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/sendotp/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": e,
        }));
    var data = jsonDecode(response.body.toString());
    tt =data['email'];
    String? error =data['error'];
    print(tt);
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>otp(email: tt,),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "OTP Send",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "$error",
                  style: TextStyle(color: Color(0xff37433c), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xfffbe0dd),
          )
      );

    }
  }
  final String youtubeLink = "https://www.youtube.com/watch?v=N5Rp_uPa5Ag";
  final String youtubeAppUrl = "vnd.youtube:";

  Future<void> _openYouTubeApp() async {
    try {
      bool launched = await launch(youtubeAppUrl);
      if (!launched) {
        // If the YouTube app is not installed, open in browser
        await _launchURL();
      }
    } catch (e) {
      print(e);
      // Handle exceptions as needed
    }
  }

  Future<void> _launchURL() async {
    try {
      if (await canLaunch(youtubeLink)) {
        await launch(youtubeLink);
      } else {
        throw 'Could not launch $youtubeLink';
      }
    } catch (e) {
      print(e);
      // Handle exceptions as needed
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: (){
                  _launchURL();
                },
                child: Container(
                  width: 380.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF9f0202),
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                      child: VideoWidget(), // Replace VideoWidget with your actual video widget
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80.h,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color:  Colors.white,),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                    BorderSide(color: Color(0xFF9f0202), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                    BorderSide(color: Color(0xFF9f0202), width: 4),
                  ),
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 60.h,),
              Container(
                decoration: BoxDecoration(
                    color:Color(0xFF9f0202),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      submitData(email.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.h),
                      primary: Color(0xFF9f0202),
                    ),
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: (){
                  Get.to(()=>Login(),transition: Transition.downToUp);
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const Login()));
                },
                child: Text('ALREADY REGISTERED',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.to(()=>Login(),transition: Transition.downToUp);
                },
                child: Text(' PLEASE SIGN IN',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

