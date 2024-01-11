import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class Review extends StatefulWidget {
  final String? mail;

  const Review({this.mail});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = "https://limo101.pythonanywhere.com/getdriverreview/";
    final requestBody = {"driver_email": widget.mail};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          notifications = List<Map<String, dynamic>>.from(jsonDecode(response.body)["reviews"]);
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
    return Scaffold(
      body: Container(
        width: 1500.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9f0202), Colors.black],
            begin: Alignment.centerLeft,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Riders Review',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLoading
                ? CircularProgressIndicator(
              color: Colors.white,
            )
                : notifications.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final DateTime timestamp =
                  DateTime.parse(notifications[index]['timestamp']);
                  final String formattedDate =
                      "${timestamp.day}-${timestamp.month}-${timestamp.year}";
                  return Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      margin: EdgeInsets.all(8.0.w),
                      padding: EdgeInsets.all(8.0.w),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Wrap(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rider Name:',
                                    style: TextStyle(color: Colors.white,fontSize: 14),
                                  ),
                                  Text(
                                    notifications[index]['user_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 40
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  Text(
                                    'Rider Review:',
                                    style: TextStyle(color: Colors.white,fontSize: 14),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    notifications[index]['review'],
                                    style: TextStyle(color: Colors.white,fontSize: 18),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    'Rider Rating:',
                                    style: TextStyle(color: Colors.white,fontSize: 14),
                                  ),
                                  SizedBox(height: 10.h,),
                                  SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: notifications[index]['rating'].toDouble(),
                                      size: 25.0.sp,
                                      color: Colors.yellowAccent,
                                      borderColor: Colors.yellowAccent,
                                      spacing:0.0
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Text(
              'No Review/Rating Available',
              style: TextStyle(fontSize: 18.sp,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
