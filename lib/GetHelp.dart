import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'FAQ.dart';


class Help extends StatefulWidget {


  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9f0202), Colors.black],
            begin: Alignment.centerLeft,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding:  EdgeInsets.all(10.0.w),
              child: Center(
                child: Text(
                  'GET HELP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            buildOption(Icons.question_answer, 'FAQ', 1),
            buildDivider(),
            buildOption(Icons.gavel, 'Legal Info', 2),
            buildDivider(),
            buildOption(Icons.support_agent, 'Contact Us', 3),
          ],
        ),
      ),
    );
  }
  Future<void> _launchCaller() async {
    final uri = Uri.parse('tel:+15165145169');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  void navigateToScreen(int rowNumber) {
    switch (rowNumber) {
      case 1:
        Get.to(()=>FAQ(),transition: Transition.rightToLeft);
        break;
      case 2:
        Get.to(()=>Screen2(),transition: Transition.rightToLeft);

        break;
      case 3:
        _launchCaller();

        break;
      default:
      // Handle other cases if needed
        break;
    }
  }

  Widget buildOption(IconData icon, String text, int rowNumber) {
    return GestureDetector(
      onTap: () {
        // Handle option selection
        navigateToScreen(rowNumber);
      },
      child: Container(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 16.0.w),
                Text(text, style: TextStyle(fontSize: 16.0.sp, color: Colors.white)),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      thickness: 1,
      height: 1,
      color: Colors.white,
    );
  }
}



class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1500.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [    Color(0xFF9f0202),
              Colors.black,], // Adjust the colors as needed
            begin: Alignment.centerLeft, // Start from the center-left
            end: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Padding(
                padding:  EdgeInsets.all(10.0),
                child: Text(
                  'LEGAL INFO',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Terms and Conditions',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                      SizedBox(height: 20.h,),
                      Text('Welcome to Limo Services Pro Please read the following terms and conditions carefully before using our mobile application.\n\nDriver Sign-Up:Drivers must sign up using email with OTP verification and provide accurate personal and vehicle information for approval.Approval is subject to verification of driver credentials and vehicle details.\n\nBooking Confirmation:Drivers will receive ride requests through the app, which they have been assigned by the admin portal.Once a driver starts a ride, user will be notified that the ride has been started.\n\nPayment Process:Drivers will receive payment for completed rides manually through cheque on weekly basis.Payments will be processed promptly upon ride completion.\n\nRide Confirmation:The admin will confirm the ride after payment confirmation.Drivers will receive details about the rider and the designated pickup location.\n\nStart of Ride:Drivers must initiate the ride through the app then it will enable users to track the progress of the ride in real time.The app will enable users to track the progress of the ride in real-time.\n\nUser Reviews:Drivers are subject to user reviews and feedback after the completion of each ride.Consistent positive reviews contribute to the driver\'s overall rating on the platform.'
                        ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    ],
                  )
              ),
              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Driver Privacy Policy',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      SizedBox(height: 20.h,),
          Text(
            'At Limo Service Pro, we are dedicated to upholding the privacy and professionalism of our drivers. Our privacy policy is designed to ensure that our drivers respect the confidentiality and boundaries of our riders while maintaining the highest standards of conduct and service.\n\n'
                'Confidentiality and Respect:\n\n'
                'Professional Conduct: Our drivers are expected to maintain a professional demeanor and treat all riders with respect and courtesy.\n'
                '\nPrivacy of Riders: Drivers must respect the privacy of our riders, refraining from discussing personal matters or asking intrusive questions.\n'
                '\nConfidentiality: Any information shared by riders during the journey must be treated with strict confidentiality and should not be disclosed to third parties.\n\n'
                'Dress Code and Personal Habits:\n\n'
                '\nStrict Dress Code: Drivers are required to wear a white t-shirt and a black suit with a tie, presenting a uniform and polished appearance to riders.\n'
                '\nNo Smoking Policy: Smoking inside the limousine is strictly prohibited to maintain a clean and fresh environment for the riders.\n\n'
                'Zero Tolerance for Harassment:\n\n'
                'No Sexual Harassment: There is zero tolerance for any form of harassment, especially sexual harassment, towards riders. Any violation of this policy will result in immediate termination of the driver.\n\n'
                'Professional Boundaries:\n\n'
                'No Personal Solicitations: Drivers are prohibited from soliciting personal services, such as becoming a personal driver for a fee, from the riders. This ensures a clear distinction between professional and personal engagements.\n\n'
                'Punctuality and Additional Services:\n\n'
                'Punctuality: Drivers are expected to be punctual for pickups and drop-offs, valuing the rider\'s time and schedule.\n\n'
                'Zero Tolerance for Sexual Harassment: We maintain a zero-tolerance policy against any form of harassment. Our commitment to your safety extends to creating an environment free from harassment, ensuring that you travel with peace of mind.\n\n'
                'Flexible Booking: We understand that travel plans can change. Our cancellation policy, while ensuring fairness to our drivers, also allows for flexibility, providing options for our customers in case unforeseen circumstances arise.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),

            ],
          ),
        ),

              SizedBox(height: 20.h,),
              Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('General Terms',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp),)),
                      SizedBox(height: 20.h,),
                      Text('Code of Conduct: Users and drivers must adhere to a code of conduct, treating each other with respect and professionalism.\n\nCancellation Policy: Users are subject to the cancellation policy outlined in the app.Cancellation fees may apply in certain circumstances.\n\nTermination of Accounts: Violation of terms may result in the termination of user or driver accounts.\n\nApp Updates: Users and drivers are responsible for updating the app to the latest version for optimal performance.'
                        ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    ],
                  )
              ),
      ]))));
  }
}

