import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Extra/videoplayer.dart';
import '../Menu.dart';
import 'Login.dart';
import 'docupload.dart';
class SignUp extends StatefulWidget {
  final String? email;
  const SignUp({this.email});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  String? tt;
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  TextEditingController c = TextEditingController();
  TextEditingController d = TextEditingController();
  TextEditingController e = TextEditingController();
  String? playerId;
  @override
  void initState() {
    super.initState();
    myFunction();
  }
  Future<void> myFunction() async {
    playerId = await OneSignal.shared.getDeviceState().then((state) => state?.userId);
    print(playerId);
  }
  submitData(String name,pno,cname,yveh,LPlate) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/driversignup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": widget.email,
          "phone_number": pno,
          "car_name": cname,
          "year_vehicle": yveh,
          "license_plate": LPlate,
          "player_id": "$playerId"
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
      print(playerId);
      Get.to(()=>DocUpload(email: tt,),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Driver information updated",
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
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.h,),
              Text('SIGN UP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28.sp),),
              SizedBox(height: 40.h,),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: a,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
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
                  hintText: 'Name',
                ),
              ),
              SizedBox(height: 30.h,),
              TextFormField(
                style: TextStyle(
                    color: Colors.white
                ),
                controller: b,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor:Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: Color(0xFF9f0202), width: 4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: Color(0xFF9f0202), width: 4),
                    ),
                    hintText: 'Enter phone number',
                    prefixIcon: CountryCodePicker(
                      initialSelection: 'US', // Set the initial selection to the country code 'US'
                      favorite: ['+1', 'US'],
                      enabled: false, // Disable user interaction with the widget
                      boxDecoration: BoxDecoration(color: Colors.white,),
                      textStyle: TextStyle(color: Colors.white),
                    )
                ),
              ),
              SizedBox(height: 30.h,),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: c,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info,
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
                  hintText: 'Vehicle Name',
                ),
              ),
              SizedBox(height: 30.h,),
              TextField(
                keyboardType: TextInputType.number,
                controller: d,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info,
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
                  hintText: 'Year of Vehicle',
                ),
              ),
              SizedBox(height: 30.h,),
              TextField(
                controller: e,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info,
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
                  hintText: 'License Plate No',
                ),
              ),
              SizedBox(height: 30.h,),

              Container(
                width: 380.w,
                decoration: BoxDecoration(
                    color:Color(0xFF9f0202),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: ElevatedButton(
                  onPressed: () {
                    submitData(a.text.trim(),b.text.trim(),c.text.trim(),d.text.trim(),e.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 110.w, vertical: 12.h),
                    primary: Color(0xFF9f0202),
                  ),
                  child: Text(
                    'SIGNUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
