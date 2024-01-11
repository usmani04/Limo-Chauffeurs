import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drivewithlimo/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import 'package:url_launcher/url_launcher.dart';

import 'GetHelp.dart';
import 'Reviews.dart';
import 'TH.dart';
import 'about.dart';
import 'auth/Login.dart';
import 'auth/firstpage.dart';
import 'job/desttrack.dart';
import 'job/getajob.dart';
import 'job/tracking.dart';
import 'notification.dart';


class Menu extends StatefulWidget {
  final String? token;
  final String? mail;
  const Menu({this.mail,this.token});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void Dialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.info,
      headerAnimationLoop: true,
      title: 'GPS Tracking Not Available',
      desc:
      'GPS tracking becomes available once the admin assigns a ride to you as a driver. Initiate your ride through the Get A Job option to enable tracking. Thank you for using our service.',
      btnOkText: 'OK',
      btnOkOnPress: () {
        // Do something when "YES" is clicked
      },
      btnOkColor: Color(0xFF207ac8),
      dismissOnTouchOutside: true,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }

  String? requestid;
  Future<void> removeTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.to(()=>First(),transition: Transition.leftToRight);
  }
  submitData() async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/drivergpstrackingcheck/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail,

        }));
    var data = jsonDecode(response.body.toString());
    requestid = data['request_id'];
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      print(widget.mail);

      if (data['ride_status'] == 'Customer is in car') {
        // Navigate to Tracking screen
        Get.to(() => destTracking(req: requestid), transition: Transition.rightToLeft);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff344439), size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Track Your Driver",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          ),
        );
      } else if (data['ride_status'] == 'Ride has been Started') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff344439), size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Track Your Driver",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          ),
        );
        Get.to(() => Tracking(req: requestid,token:widget.token,mail:widget.mail), transition: Transition.rightToLeft);
      } }else {
      Dialog(context);

    }
  }
  List<Map<String, dynamic>> notifications = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    final apiUrl = "https://limo101.pythonanywhere.com/drivernoti/";
    final requestBody = {"email": widget.mail};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  WillPopScope(
      onWillPop: () async {
        // Return false to prevent back navigation
        return false;
      },
      child: Scaffold(
        body: Column(children: [
          Expanded(child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft, // Start from the center-left
                end: Alignment.centerRight, // End at the center-right
                colors: [Color(0xFF9f0202), Colors.black], // Define your gradient colors
                // Adjust stops to position the second color in the center
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
SizedBox(height: 50.h),
                  Center(child: Text("LIMOUSINE SERVICES PRO",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp),)),
                  SizedBox(height: 10.h),
                  Center(child: Text("www.limoservicespro.com",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                  SizedBox(height: 10.h),
                  Center(child: Text("1-800-835-7085",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                  SizedBox(height: 10.h),
                  Center(child: Text("516-779-1862",style: TextStyle(color :Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                  SizedBox(height: 30.h),
                  GestureDetector(
                      onTap: ()
                      {

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),

                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>AboutUsScreen(),transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "About Us",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),

                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>Getajob(token: widget.token,mail: widget.mail,),transition: Transition.rightToLeft);

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Get a job",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        submitData();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "GPS Tracking",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => NotificationScreen(mail: widget.mail,), transition: Transition.rightToLeft);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(18.0.sp),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.white, size: 15.sp),
                              SizedBox(width: 30.w),
                              Text(
                                "Notification",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Badge indicating new messages
                          Positioned(
                            top: 0.0,
                            right: 140.0,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red, // Choose the color you want for the badge
                              ),
                              child: Text(
                                "${notifications.length}", // You can replace this with the actual count of new messages
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>WalletScreen(mail: widget.mail,),transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Wallet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>TH(mail: widget.mail,),transition: Transition.rightToLeft);

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Travel History",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>Review(mail: widget.mail,),transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Riders Review",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        Get.to(()=>Help(),transition: Transition.rightToLeft);

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Get Help",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: ()
                      {

                        removeTokenFromSharedPreferences();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white,size: 15.sp),
                            SizedBox(width: 30.w),
                            Text(
                              "Exit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
          ))
        ],),
      ),
    );
  }
}
