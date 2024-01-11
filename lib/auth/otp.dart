import 'dart:convert';

import 'package:drivewithlimo/auth/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pinput/pin_put/pin_put.dart';


class otp extends StatefulWidget {
  final String? email;
  const otp({this.email});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {

  final FocusNode _pinPutFocusNode = FocusNode();
  TextEditingController _otpController = TextEditingController();
  String? tt;
  submitData(String e) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/verifyotp/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": e
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
      Get.to(()=>SignUp(email: tt,),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "OTP Verified",
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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 100.h),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  "VERIFY OTP",
                  style:TextStyle(
                    letterSpacing: 2,
                    fontSize: 28.sp,
                    color:
                    Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                  "Enter the 4-digit verification code sent to your email",
                  style:TextStyle(
                    fontSize: 18.sp,
                    color:
                    Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: PinPut(
                  fieldsCount: 4,
                  textStyle:  TextStyle(fontSize: 25.0.sp, color: Colors.white,),
                  eachFieldWidth: 60.0.w,
                  eachFieldHeight: 70.0.h,
                  focusNode: _pinPutFocusNode,
                  controller: _otpController,
                  submittedFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:Colors.black,
                  ),
                  selectedFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF9f0202),
                    border: Border.all(
                      color: Color(0xFF9f0202),
                    ),
                  ),
                  followingFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFF9f0202),
                    border: Border.all(
                      color:Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60.h,),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    submitData(_otpController.text.trim());
                  },
                  child: Text('VERIFY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(90.w, 15.h, 90.w, 15.h),
                    primary:  Color(0xFF9f0202),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 8.0,
                  )),
            ),

          ],
        ),
      ),
    );
  }
}
