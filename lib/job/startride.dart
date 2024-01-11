import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'tracking.dart';

class Startride extends StatefulWidget {
  final String? mail;
  final String? token;
  const Startride({this.mail,this.token});

  @override
  State<Startride> createState() => _StartrideState();
}

class _StartrideState extends State<Startride> {
  List<Map<String, dynamic>> rideData = [];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      fetchData();
    });
  }
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }
  void _startRide(String requestId) async {
    try {
      final response = await http.post(
        Uri.parse('https://limo101.pythonanywhere.com/startride/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"request_id": requestId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        print(requestId);
        String? req =responseData['request_id'];
        // Check the response and navigate to the next screen if needed
        if (responseData["message"] == "Ride has been started. Notification sent to user.") {
Get.to(()=>Tracking(req: req,mail: widget.mail,token: widget.token,));
print( widget.mail);print( widget.token,);
        } else {
          // Handle other cases if necessary
        }
      } else {
        throw Exception('Failed to start the ride');
      }
    } catch (error) {
      print('Error starting ride: $error');
      // Handle the error as needed
    }
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('https://limo101.pythonanywhere.com/driverbooking/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email":  widget.mail!}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        rideData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('NO ride available');
    }
  }
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        width: 500.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF9f0202), Colors.black],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Center(
              child: Text(
                'GET A JOB',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            isLoading
                ? CircularProgressIndicator(
              color: Colors.white,
            )
                : rideData.isNotEmpty?  Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: rideData.length,
                  itemBuilder: (context, index) {
                    final ride = rideData[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 470.w,
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.yellow,
                                            radius: 40.r,
                                            backgroundImage: NetworkImage(
                                              'https://limo101.pythonanywhere.com${ride["user_profile_pic"]}',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 20.w,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Customer Name', style: TextStyle(color: Colors.black, fontSize: 13.sp),),
                                          Text('${ride["name"]}', style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.bold),),
                                          Text('PICKUP DISTANCE: ${ride["pickup_distance"]} Km', style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                                          Text('DESTINATION DISTANCE: ${ride["destination_distance"]} Km', style: TextStyle(color: Colors.black, fontSize: 12.sp),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h,),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showDialog('Pickup Location', ride["current_location"]);
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 200.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black, width: 6),
                                                color: Color(0xFF9f0202),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'PICKUP LOCATION',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h,),
                                          GestureDetector(
                                            onTap: () {
                                              _showDialog('Destination Location', ride["destination_location"]);
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 200.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black, width: 6),
                                                color: Color(0xFF9f0202),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'DESTINATION LOCATION',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 5.w,),
                                      GestureDetector(
                                        onTap: () {
                                          // Use the request_id for starting the ride
                                          _startRide(ride["request_id"]);
                                        },
                                        child: Container(
                                          width: 85.0.w,
                                          height: 85.0.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black, width: 5.w),
                                            shape: BoxShape.circle,
                                            color: Color(0xFF68ff00),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('START', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),),
                                              Text('RIDE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('PICKUP DATE: ${ride["date"]}', style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('PICKUP TIME: ${ride["time"]}', style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.bold),),
                                )
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFF9f0202), width: 8),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    );
                  },
                ),
              ),
            ) : Center(
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: Text(
      'No jobs available currently. Please check back later. You will receive a notification when the admin assigns you a ride. Your assigned rides will be displayed here.',
      style: TextStyle(fontSize: 18.sp,color: Colors.white),
    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
          content: Text(content,style: TextStyle(fontSize: 18.sp),),
        );
      },
    );
  }


}
