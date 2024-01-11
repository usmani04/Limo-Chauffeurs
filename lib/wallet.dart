import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
class WalletScreen extends StatefulWidget {

  final String? mail;
  const WalletScreen({this.mail});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int? total_bookings;
  double? walletAmount;
  @override
  void initState() {
    super.initState();
    submitData();
  }
  submitData() async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/wallet/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.mail
        }));
    var data = jsonDecode(response.body.toString());

    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
setState(() {
  walletAmount =data['wallet'];
  total_bookings=data['total_bookings'];
});

    } else {

    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9f0202), Colors.black],
            begin: Alignment.centerLeft,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.black], // Adjust gradient colors as needed
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Bookings: ${total_bookings??''}',
                      style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                      'Wallet Amount: \$${walletAmount?.toStringAsFixed(2)??''}',
                      style: TextStyle(color: Colors.white, fontSize: 24.0.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
