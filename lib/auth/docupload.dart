import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drivewithlimo/auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
class DocUpload extends StatefulWidget {
  final String? email;
  const DocUpload({this.email});

  @override
  State<DocUpload> createState() => _DocUploadState();
}

class _DocUploadState extends State<DocUpload> {
  static Future<bool> requestgalleryPermission() async {
    final status = await Permission.photos.request();

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
    requestgalleryPermission();
  }
  void showCustomDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success, // Change this to the desired dialog type
      animType: AnimType.bottomSlide,
      title: 'Document Verification and Approval',
      desc: 'Thank you for submitting your documents; our administrator will verify their legitimacy. You will get an email with your login password if your verification is successful. To access the app, use this password along with your registered email address.',
      headerAnimationLoop: true,
      btnOkOnPress: () {
        Get.to(() => Login(), transition: Transition.rightToLeft, duration: Duration(seconds: 1));
      },
      btnOkText: 'OK',
      btnOkColor: Color(0xFF00ca71),
      dismissOnTouchOutside: false,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }
  Future<void> sendFormData(
      PickedFile? image,
      PickedFile? img,
      PickedFile? ii,
      PickedFile? ig,
      PickedFile? i,
      String email,
      ) async {
    final url =
    Uri.parse('https://limo101.pythonanywhere.com/pictureupload/');
    final request = http.MultipartRequest('POST', url);

    if (image != null) {
      final imageFile =
      await http.MultipartFile.fromPath('car_image', image.path);
      request.files.add(imageFile);
    }

    if (img != null) {
      final imageFile =
      await http.MultipartFile.fromPath('driving_license', img.path);
      request.files.add(imageFile);
    }

    if (ii != null) {
      final imageFile =
      await http.MultipartFile.fromPath('license_plate', ii.path);
      request.files.add(imageFile);
    }

    if (ig != null) {
      final imageFile = await http.MultipartFile.fromPath('car_insurance_image', ig.path);
      request.files.add(imageFile);
    }

    if (i != null) {
      final imageFile = await http.MultipartFile.fromPath('driver_profilepic', i.path);
      request.files.add(imageFile);
    }

    request.fields.addAll({
      'email': email,
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      showCustomDialog(context);

      print(widget.email);
      print(image!.path);
      print(img!.path);
      print(ii!.path);
      print(ig!.path);
      print(i!.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "INVALID CREDENTIALS", style: TextStyle(
              color: Colors.white, fontSize: 18,letterSpacing: 2
          )
          ),
          backgroundColor: Colors.red,
        ),
      );
      print(response.statusCode);
      print(email);
      print(image!.path);
      print(img!.path);
      print(ii!.path);
      print(ig!.path);

      print('Failed to send form data');
    }
  }

  PickedFile? _image;
  PickedFile? _img;
  PickedFile? _ii;
  PickedFile? _ig;
  PickedFile? _i;
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _pick() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _img = pickedImage;
    });
  }

  Future<void> _pk() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _ii = pickedImage;
    });
  }

  Future<void> _pic() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _ig = pickedImage;
    });
  }
  Future<void> _p() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _i = pickedImage;
    });
  }
  Future<void> _postForm() async {
    final email = widget.email;
    final response = await sendFormData(
      _image,
      _img,
      _ii,
      _ig,
      _i,
      email!,
    );
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
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    "UPLOAD DOCS",
                    style:TextStyle(
                      letterSpacing: 2,
                      fontSize: 28.sp,
                      color:
                      Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _p,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFe6e6e6),
                      border: Border.all(color: Color(0xFF9f0202),width: 8)
                  ),
                  child: _i != null
                      ? Image.file(
                    File(_i!.path),
                    fit: BoxFit.fill,
                  )
                      : Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('UPLOAD',style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.bold),)),
                        SizedBox(height: 10.h,),
                        Center(child: Text('PROFILE PIC',style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                  height: 150.h,
                  width: 150.w,
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFe6e6e6),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Color(0xFF9f0202),width: 8)
                  ),
                  child: _image != null
                      ? Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  )
                      : Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('CLICK HERE',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                        SizedBox(height: 10,),
                        Center(child: Text('Car Photo Upload',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                  height: 180.h,
                  width: 350.w,
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: _pick,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFe6e6e6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFF9f0202),width: 8)
                  ),
                  child: _img != null
                      ? Image.file(
                    File(_img!.path),
                    fit: BoxFit.cover,
                  )
                      :   Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('CLICK HERE',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 10,),
                    Center(child: Text('Driving License',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                    Center(child: Text('Photo Upload',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                  ],
                ),
                  height: 180.h,
                  width: 350.w,
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: _pk,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFe6e6e6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFF9f0202),width: 8)
                  ),
                  child: _ii != null
                      ? Image.file(
                    File(_ii!.path),
                    fit: BoxFit.cover,
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text('CLICK HERE',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10,),
                      Center(child: Text('License Plate',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                      Center(child: Text('Photo Upload',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  height: 180.h,
                  width: 350.w,
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap:  _pic,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFe6e6e6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFF9f0202),width: 8)
                  ),
                  child: _ig != null
                      ? Image.file(
                    File(_ig!.path),
                    fit: BoxFit.cover,
                  )
                      :  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text('CLICK HERE',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10,),
                      Center(child: Text('Vehicle Insurance',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                      Center(child: Text('Photo Upload',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  height: 180.h,
                  width: 350.w,
                ),
              ),
              SizedBox(height: 30.h,),

              Container(
                width: 360.w,
                decoration: BoxDecoration(
                    color:Color(0xFF9f0202),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _postForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 110.w, vertical: 15.h),
                    primary: Color(0xFF9f0202),
                  ),
                  child: Text(
                    'UPLOAD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
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
