import 'dart:async';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import '../Menu.dart';
import 'desttrack.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
class Tracking extends StatefulWidget {
  final String? req;
  final String? token;
  final String? mail;
  const Tracking({this.req,this.token,this.mail});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      submitData();
    });
  }
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }
Data() async {
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/customerincar/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "request_id": widget.req
        }));
    var data = jsonDecode(response.body.toString());
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);
    if (response.statusCode == 200) {
      _timer?.cancel();
      Get.to(()=>destTracking(req:widget.req),transition: Transition.rightToLeft);
      print('sucess');

    } else {

    }
  }
  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          content: Text('Are you sure you want to select this option? Once confirmed, you cannot go back.',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Data();
              },
              child: Text('YES',style: TextStyle(fontSize: 18),),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and perform another action
                Navigator.of(context).pop();
                // Add your code here for the second button action
              },
              child: Text('NO',style: TextStyle(fontSize: 18),),
            ),
          ],
        );
      },
    );
  }
  Timer? _timer;
  String? Dname;
  double? rating;
  String? pic;
  double? etime;
  String? pno;
  GoogleMapController? _mapController;
  LatLng _driverLocation = LatLng(0, 0);
  LatLng _userLocation = LatLng(0, 0);
  Set<Polyline> _polylines = {};
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
  void _createPolylines() async {
    if (_driverLocation == null || _userLocation == null) {
      print('Driver or user location is null. Cannot create polylines.');
      return;
    }

    final String apiKey = 'AIzaSyCDRUUy5StFdFvvlawFOtYI1AHos1eRTvM';
    final String origin = '${_driverLocation.latitude},${_driverLocation.longitude}';
    final String destination = '${_userLocation.latitude},${_userLocation.longitude}';
    final String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      _loadMarkerIcons();
      final Map<String, dynamic> data = json.decode(response.body);
      List<LatLng> polylineCoordinates = _decodePolyline(data['routes'][0]['overview_polyline']['points']);

      final PolylineId polylineId = PolylineId("polyline_id");
      Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Color(0xFF9f0202),
        points: polylineCoordinates,
        width: 4,
        patterns: [PatternItem.dash(70), PatternItem.gap(40)],
      );

      setState(() {
        _polylines.add(polyline);
      });

      _fitMapToBounds();
    } else {
      print('Failed to fetch directions. Status code: ${response.statusCode}');
    }
  }
  void _fitMapToBounds() {
    if (_driverLocation == null || _userLocation == null) {
      print('Driver or user location is null. Cannot fit map to bounds.');
      return;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(_driverLocation.latitude, _userLocation.latitude),
        min(_driverLocation.longitude, _userLocation.longitude),
      ),
      northeast: LatLng(
        max(_driverLocation.latitude, _userLocation.latitude),
        max(_driverLocation.longitude, _userLocation.longitude),
      ),
    );

    final double padding = 50.0;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }
  submitData() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    var response = await post(Uri.https('limo101.pythonanywhere.com', '/driverpickup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "request_id": widget.req,
          "driver_coordinates": {
            "current_lat": currentPosition.latitude,
            "current_long": currentPosition.longitude
          }
        }));
    var data = jsonDecode(response.body.toString());
    print(data);
    print(response.statusCode);
    String responseString = response.body;
    print(responseString);

    if (response.statusCode == 200) {
 driverLatitude = double.parse(data['driver_current_coordinates']['current_lat'].toString());
   driverLongitude = double.parse(data['driver_current_coordinates']['current_long'].toString());
   userLatitude = double.parse(data['user_current_coordinates']['current_lat'].toString());
   userLongitude = double.parse(data['user_current_coordinates']['current_long'].toString());
      setState(() {
        if (data['ride status'] == "Customer is in car") {
          _timer?.cancel();
          Get.to(()=>destTracking(),transition: Transition.rightToLeft);
        }
        Dname = data['name'];
        pic = data['user_profilepic'];
        etime = data['estimated_time_minutes'];
        pno= data['phone_number'];
        _driverLocation = LatLng(driverLatitude!, driverLongitude!);
        _userLocation = LatLng(userLatitude!, userLongitude!);

      });
      print('succ');
      _createPolylines();
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
  Future<void> _launchCaller() async {
    final uri = Uri.parse('tel:${pno}');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  Future<void> _launchSms() async {
    final uri = Uri.parse('sms:${pno}');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  BitmapDescriptor? _driverIcon;
  BitmapDescriptor? _userIcon;
  String? carname;
  String? vehyear;
  String? license;
  String? img;
  double? userLatitude;
  double? userLongitude;
  double? driverLatitude;
  double? driverLongitude;
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child:  Container(
                  height: 90,width: 90,
                  child: Image.network('https://limo101.pythonanywhere.com${img}',fit: BoxFit.fill,))), // Replace 'assets/your_image.png' with your image path
              SizedBox(height: 10,),
              Center(child: Text('CAR INFO',style: TextStyle(fontSize: 22,color: Color(0xFF9f0202),fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
              Text('License Plate No: $license',style: TextStyle(fontSize: 18,color: Color(0xFF9f0202)),),
              Text('Car Name: $carname',style: TextStyle(fontSize: 18,color: Color(0xFF9f0202)),),
              Text('Year of Vehicle: $vehyear',style: TextStyle(fontSize: 18,color: Color(0xFF9f0202)),),
            ],
          ),
        );},
      barrierColor: Colors.black.withOpacity(0.9),
    );
  }
  Future<void> _loadMarkerIcons() async {
    _driverIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(8, 8)),
      'images/fort.png',
    );
    _userIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'images/user.png',
    );
  }
  void launchNavigation() async {
    if (_userLocation != null) {
      final String origin = '${driverLatitude},${driverLongitude}';
      final String destination = '${userLatitude},${userLongitude}';
      final String url = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch Google Maps navigation.');
      }
    } else {
      print('User location is not available.');
    }
  }
  Future<void> _launch() async {
    final uri = Uri.parse('tel:+15165145169');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  void Dialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.info,
      headerAnimationLoop: true,
      title: 'CUSTOMER ABSENT AT LOCATION',
      desc:
      'Customer Unavailable at Pick-Up. Contact Admin for Investigation and Ride Cancellation.',
      btnOkText: 'Call Admin',
      btnOkOnPress: () {
        _launch();
      },
      btnOkColor: Color(0xFF207ac8),
      dismissOnTouchOutside: true,
      barrierColor: Colors.black.withOpacity(0.9),
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  WillPopScope(
      onWillPop: () async {
        _timer?.cancel();
        Get.to(()=>Menu(mail: widget.mail,token: widget.token,),transition: Transition.leftToRight);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFf1f3f4),
        body: Column(
          children: [
            Container(
              color: Color(0xFFf1f3f4),
              height: 220.h,
              child:  Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        ((_driverLocation?.latitude ?? 0) + (_userLocation?.latitude ?? 0)) / 2,
                        ((_driverLocation?.longitude ?? 0) + (_userLocation?.longitude ?? 0)) / 2,
                      ),
                      zoom: 8.0, // Adjust the zoom level as needed
                    ),
                    polylines: _polylines,
                    markers: {
                      Marker(
                        markerId: MarkerId('driver_marker'),
                        position: _driverLocation ?? LatLng(0, 0),
                        icon:_driverIcon ?? BitmapDescriptor.defaultMarker,
                      ),
                      Marker(
                        markerId: MarkerId('user_marker'),
                        icon:_userIcon ?? BitmapDescriptor.defaultMarker,
                        position: _userLocation ?? LatLng(0, 0),
                      ),
                    },
                  ),
                  Positioned(
                    top: 50.0,
                    left: 20.0,
                    child: GestureDetector(
                      onTap: (){
                        launchNavigation();
                      },
                      child: Container(
                        width: 50,height: 50,
                        color: Color(0xFFf1f3f4),
                        child:Image.asset('images/Capture.PNG',fit: BoxFit.contain,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  width: 1000.w,
                  child: Padding(
                    padding:  EdgeInsets.all(28.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF9f0202),
                                radius: 50.r,
                                backgroundImage: NetworkImage('https://limo101.pythonanywhere.com${pic}'), // Replace with your image path
                              ),
                              SizedBox(width: 10.w),
                              Padding(
                                padding:  EdgeInsets.all(8.0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer Name',style: TextStyle(color: Colors.white,fontSize: 15.sp),),
                                    Text('${Dname??''}',style: TextStyle(color: Colors.white,fontSize: 28.sp,fontWeight: FontWeight.bold),),

                                  ],),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Duration',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),)
                                  ,SizedBox(height: 20.h),
                                  Text(
                                    'Call',
                                    style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                                  ),SizedBox(height: 20.h),
                                  Text('Message',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),)
                                  ,
                                ],),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${etime??''} min',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),)
                                  ,SizedBox(height: 20.h), GestureDetector(
                                      onTap: (){
                                        _launchCaller();
                                      },
                                      child: Icon(Icons.call, color: Colors.white)),SizedBox(height: 20.h),
                                  GestureDetector(
                                      onTap: (){
                                        _launchSms();
                                      },
                                      child: Icon(Icons.message,color: Colors.white,))
                                ],
                              ),
                            ],),
                          SizedBox(height: 30.h),
                          Center(
                            child: Container(
                              width: 380.w,
                              decoration: BoxDecoration(
                                  color:Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                                  primary: Colors.black,
                                ),
                                child: Text(
                                  'CUSTOMER IN CAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Center(
                            child: Container(
                              width: 380.w,
                              decoration: BoxDecoration(
                                  color:Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Dialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                                  primary: Colors.black,
                                ),
                                child: Text(
                                  'CUSTOMER ABSENT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFF9f0202),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(45),topRight:Radius.circular(45))
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
