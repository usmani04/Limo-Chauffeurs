import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drivewithlimo/job/startride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../extra/assistant.dart';
import '../extra/handler.dart';

class Getajob extends StatefulWidget {
  final String? token;
  final String? mail;
  const Getajob({this.token,this.mail});

  @override
  State<Getajob> createState() => _GetajobState();
}

class _GetajobState extends State<Getajob> {
  LocationPermission? _locationPermission;
  bool isOffline = true;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  Position? userCurrentPosition;

  // Initial camera position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    delayedInit();
    checkIfLocationPermissionAllowed();
  }

  // Function to check and request location permissions
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.checkPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    if (_locationPermission == LocationPermission.whileInUse) {
      locateUserPosition();
    }
  }
  Future<void> delayedInit() async {
    await Future.delayed(Duration(seconds: 2));
    Data();
  }
  // Function to update the user's location on the map
  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);


  }
  void Dialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.info,
      headerAnimationLoop: true,
      title: 'Pending Ride Found',
      desc:
      'Finish your ongoing ride with GPS tracking selected before accepting a new job. Only after completing your current ride will you be able to take on a new one.',
      btnOkText: 'OK',
      btnOkOnPress: () {
        // Do something when "YES" is clicked
      },
      btnOkColor: Color(0xFF207ac8),
      dismissOnTouchOutside: true,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }
  submit() async {
    final response = await http.post(
      Uri.https('limo101.pythonanywhere.com', '/checkongoingride/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.mail,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      msg =data['message'];
      print('success');
      if (msg == "Complete your previous ride before accepting a new one") {
        Dialog(context);
      } else {
        Get.to(()=>Startride(mail:widget.mail,token: widget.token,),transition: Transition.rightToLeft);
      }
    } else {


    }
  }
  String? msg;
  submitData() async {
    String activeStatus = isOffline ? "offline" : "online";

    final response = await http.post(
      Uri.https('limo101.pythonanywhere.com', '/statusdriver/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": widget.token,
        "active": activeStatus,
      }),
    );

    if (response.statusCode == 200) {
  print('success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text(
                "offline",
                style: TextStyle(color: Color(0xff37433c), fontSize: 18),
              ),
            ],
          ),
          backgroundColor: Color(0xfffbe0dd),
        ),
      );
    }
  }
Data() async {

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark first = placemarks.first;
  String address = "${first.street},${first.subThoroughfare}, ${first.thoroughfare}, ${first.locality}, ${first.administrativeArea}, ${first.country}";
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/driverlocation/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token":widget.token,
          "current_location": address,
          "current_coordinates": {
            "current_lat":position.latitude.toString(),
            "current_long":   position.longitude.toString(),
          },

        }));
    var data = jsonDecode(response.body.toString());
    print(data);
    String? dd = data['message'];
    print(dd);

    print(response.statusCode);

    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      print(address);
      print(position.latitude.toString());
      print(position.longitude.toString());
   } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel,color: Colors.red,size: 20,),
                SizedBox(width: 10,),
                Text(
                  "Failed",
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
  _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locateUserPosition();
            },
          ),
          if (isOffline)
            Container(
              color: Colors.black.withOpacity(0.9),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Text(
                  'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ),
          if (!isOffline)
            Positioned(
              bottom: 46.0.h,
              right: 20.0.w,
              child: Container(
                width: 320.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 6),
                  color: Color(0xFF9f0202),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                   submit();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 98.w, vertical: 15.h),
                    primary: Color(0xFF9f0202),
                  ),
                  child: Text(
                    'GET A JOB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 30.0.h,
            right: 20.0.w,
            child: Row(
              children: [
                FlutterSwitch(
                  inactiveText: isOffline ? 'Offline' : 'Online',
                  activeText: isOffline ? 'Offline' : 'Online',
                  activeTextColor: Colors.black,
                  activeColor: Color(0xFF68ff00),
                  inactiveColor: Color(0xFFff0000),
                  width: 140.0.w,
                  height: 40.0.h,
                  valueFontSize: 18.0.sp,
                  toggleSize: 45.0,
                  borderRadius: 30.0.r,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      isOffline = !value;
                    });
                    submitData();
                  },
                  value: !isOffline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
