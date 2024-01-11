import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: "How do I create an account?",
      answer:
      "Sign up using your email with OTP verification and provide accurate personal and vehicle information for approval.",
    ),
    FAQItem(
      question: "It's important to upload my document picture?",
      answer:
      "Yes it's important,Your Data is completely secured.We are asking these doc from you for verification after verification Admin will approved your Request and you got your Password on your email.",
    ),
    // Add more FAQ items here

    FAQItem(
      question: "How do I receive ride requests?",
      answer:
      "Ride requests will be sent to you through the app, assigned by the admin portal after payment confirmation.",
    ),
    FAQItem(
      question: "How and when do I get paid?",
      answer:
      "Payments for completed rides are processed manually through a cheque on a weekly basis.",
    ),
    FAQItem(
      question: "Can users track my progress during a ride?",
      answer:
      "Yes, users can track your progress in real-time once you initiate the ride through the app.",
    ),
    FAQItem(
      question: "What happens if I receive negative reviews?",
      answer:
      "User reviews and feedback contribute to your overall rating. Consistent positive reviews are important for your profile on the platform.",
    ),
    // Add more driver FAQs here
    FAQItem(
      question: "What is the Code of Conduct for users and drivers?",
      answer: "Users and drivers are expected to treat each other with respect and professionalism.",
    ),

    FAQItem(
      question: "What happens if I violate the terms and conditions?",
      answer: "Violation of terms may result in the termination of user or driver accounts.",
    ),
    FAQItem(
      question: "How do I stay updated with the latest app features?",
      answer: "Users and drivers are responsible for updating the app to the latest version for optimal performance.",
    ),
    FAQItem(
      question: "What is the aim of Limo Services Pro?",
      answer: "Limo Services Pro aims to provide a seamless and reliable transportation experience for all users.",
    ),
    // Add more general FAQs here
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Start from the center-left
            end: Alignment.centerRight, // End at the center-right
            colors: [Color(0xFF9f0202), Colors.black], // Define your gradient colors
            // Adjust stops to position the second color in the center
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'F.A.Q.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Expanded(
              child: ListView.builder(
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: FAQItemWidget(
                      faqItem: faqItems[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQItemWidget extends StatelessWidget {
  final FAQItem faqItem;

  FAQItemWidget({required this.faqItem});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        title: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,color: Colors.white,size: 18.sp,),
                  SizedBox(width: 10.w,),
                  Text(
                    faqItem.question,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(faqItem.question),
                content: Text(faqItem.answer),
              );
            },
          );
        },
      ),
    );
  }
}
