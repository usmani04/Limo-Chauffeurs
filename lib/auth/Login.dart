import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../extra/videoplayer.dart';
import '../menu.dart';
import '../token/token.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _saveToken = false;
  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String? tt;  String? mail;
  submitData(String email,password) async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/driverlogin/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }));
    var data = jsonDecode(response.body.toString());
    tt =data['token'];
    mail=data['email'];
    print(tt);
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      Get.to(()=>Menu(token: tt,mail: mail,),transition: Transition.rightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,color: Color(0xff344439),size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Login Success",
                  style: TextStyle(color: Color(0xff344439), fontSize: 18),
                ),
              ],
            ),
            backgroundColor: Color(0xffb6dcc3),
          )
      );
      await TokenHandler.saveEmail(mail!);
      await TokenHandler.saveToken(tt!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Login Failed",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                      "SIGN IN",
                      style:TextStyle(
                        letterSpacing: 2,
                        fontSize: 28.sp,
                        color:
                        Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Text(
                  "Sign in with the password dispatched to your email upon successful admin approval",
                  style:TextStyle(
                    letterSpacing: 0,
                    fontSize: 15.sp,
                    color:
                    Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 20.h,),
              Container(
                width: 380.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF9f0202),
                    width: 4.w,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                      aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                      child: Image.asset('images/j.gif',fit: BoxFit.cover,)// Replace VideoWidget with your actual video widget
                  ),
                ),
              ),


              SizedBox(height: 30.h,),
              TextField(
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
              SizedBox(height: 20.h,),
              TextField(
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
                controller: pass,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
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
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 40.h,),
              Container(
                decoration: BoxDecoration(
                    color:Color(0xFF9f0202),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                     submitData(email.text.trim(), pass.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.h),
                      primary: Color(0xFF9f0202),
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
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
