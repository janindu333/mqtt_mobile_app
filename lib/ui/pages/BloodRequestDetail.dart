// ignore_for_file: file_names, prefer_const_constructors

import 'dart:math';

import 'package:bloodDonate/blocks/AuthProvider.dart';
import 'package:bloodDonate/blocks/blood_request_block_provider.dart';
import 'package:bloodDonate/common/colors.dart';
import 'package:bloodDonate/ui/Animation/FadeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bloodDonate/ui/utils/blood_types.dart';
import 'package:bloodDonate/ui/utils/tools.dart';
import 'package:bloodDonate/ui/utils/validators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_place/google_place.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:intl/intl.dart';

class BloodRequestDetail extends StatefulWidget {
  static const String routeName = '/bloodrequestdetail';
  final String bloodGroup,
      requesterName,
      addedTime,
      numberOfUnits,
      address,
      medicalCenterName,
      contactNumber;

  const BloodRequestDetail(
      {this.bloodGroup,
      this.requesterName,
      this.addedTime,
      this.numberOfUnits,
      this.address,
      this.medicalCenterName,
      this.contactNumber});

  @override
  _BloodRequestDetailState createState() => _BloodRequestDetailState();
}

class _BloodRequestDetailState extends State<BloodRequestDetail> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String _bloodType = "A+";
  DateTime _requestDate;
  bool _isLoading = false;
  bool _isSelected = false;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  String _patientNameEmpty = "Please enter patient name";
  String _contactNumberEmpty = "Please enter contact number";
  String _addressEmpty = "Please enter address";
  String _requestDateEmpty = "Please enter request date";
  GooglePlace googlePlace;
  String lat;
  String long;
  List<AutocompletePrediction> predictions = [];
  bool _isVisible = false;

  GoogleMapController _googleMapController;

  @override
  void initState() {
    // TODO: implement initState
    String apiKey = "AIzaSyDBU32ihKNmFIEb6nS3nTNm6TwMpTdR9Eg";
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage('assets/images/feturedEvent.jpg'), context);
    super.didChangeDependencies();
  }

  void showtoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    // _eventNameController?.dispose();
    // _descriptionController?.dispose();
    // _addressController.dispose();
    // _noteController?.dispose();
    //  _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    const elementsSpacer = SizedBox(height: 16);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                width: width,
                child: SizedBox(
                  height: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(),
                      image: DecorationImage(
                        image: AssetImage('assets/images/feturedEvent.jpg'),
                        fit: BoxFit.fill,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 370,
                width: width,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0))),
                  height: 800.0,
                  child:
                   Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Container(
                        width: 350,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/user_avatar.jpg'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  widget.requesterName,
                                  style: TextStyle(
                                      color: Color.fromRGBO(49, 39, 79, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                ),
                              )
                            ]),
                      )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 0.6,
                            indent: 5,
                            endIndent: 5,
                          )),
                      const SizedBox(height: 20),
                      FadeAnimation(
                        0.5,
                        Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: Container(
                                height: 320,
                                width: 360,
                                child: Column(children: [
                                  Expanded(
                                    child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/bloodDrop.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Blood Group  ",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "-  " + widget.bloodGroup,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/distance.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Number of units  ",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "-  " + widget.numberOfUnits,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/locationpin.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Address  ",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "-  " + widget.address,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/distance.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Medical center name  ",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "-  " + widget.medicalCenterName ??
                                            "Not specified",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/distance.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Required date  ",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        widget.addedTime != null
                                            ? "-  " +
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        widget.addedTime))
                                            : "-  Not specified",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FadeAnimation(
                                    0.5,
                                    InkWell(
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 60),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Color.fromRGBO(13, 50, 77, 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Make a call",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          UrlLauncher.launch(
                                              "tel://" + widget.contactNumber);
                                        }),
                                  ),
                                ]))),
                      ),
                    ],
                  ),
                
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> getCoordinates(address) async {
    try {
      final query = address;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      lat = first.coordinates.latitude.toString();
      long = first.coordinates.longitude.toString();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      setState(() => _isLoading = false);
    }
  }

  Widget _headerImage(String url) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 230,
            child: CustomPaint(painter: _MyPainter()),
          ),
        ],
      );

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final requests =
            FirebaseFirestore.instance.collection('blood_requests');
        await requests.add({
          'uid': user.uid,
          'submittedBy': user.displayName,
          'patientName': _eventNameController.text,
          'bloodType': _bloodType,
          'contactNumber': _descriptionController.text,
          'note': _noteController.text,
          'submittedAt': DateTime.now(),
          'requestDate': _requestDate,
          'isFulfilled': false,
        });
        _resetFields();
        Fluttertoast.showToast(msg: 'Request successfully Submitted');
        // Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _eventNameField() => TextFormField(
        controller: _eventNameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        validator: (v) => Validators.required(v, 'Event name'),
        decoration: InputDecoration(
          labelText: 'Event Name',
          fillColor: Colors.white,
          // border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontFamily: "Poppins",
        ),
      );

  Widget _descriptionField() => TextFormField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 5,
        validator: (v) =>
            Validators.required(v, 'Description') ?? Validators.phone(v),
        decoration: const InputDecoration(
          labelText: 'Description',
          prefixText: '',
        ),
      );

  Widget _addressField() => TextFormField(
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        validator: (v) =>
            Validators.required(v, 'address') ?? Validators.phone(v),
        decoration: const InputDecoration(
          labelText: 'Address',
          prefixText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            autoCompleteSearch(value);
          } else {
            if (predictions.length > 0 && mounted) {
              setState(() {
                predictions = [];
              });
            }
          }
        },
      );

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        _isVisible = true;
      });
      setState(() {
        predictions = result.predictions;
      });
    } else {
      predictions.clear();
    }
  }

  Widget _noteField() => TextFormField(
        controller: _noteController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        minLines: 3,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Notes (Optional)',
          alignLabelWithHint: true,
        ),
      );

  Widget _bloodTypeSelector() => DropdownButtonFormField<String>(
        value: _bloodType,
        onChanged: (v) => setState(() => _bloodType = v),
        decoration: const InputDecoration(
          labelText: 'Blood Type',
        ),
        items: BloodTypeUtils.bloodTypes
            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
            .toList(),
      );

  Widget _requestDatePicker() => GestureDetector(
        onTap: () async {
          final today = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: today.add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _requestDate = picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            key: ValueKey<DateTime>(_requestDate ?? DateTime.now()),
            initialValue: Tools.formatDate(_requestDate),
            validator: (_) =>
                _requestDate == null ? '* Please select a date' : null,
            decoration: const InputDecoration(
              labelText: 'Request date',
              helperText: 'The date on which you need the blood to be ready',
            ),
          ),
        ),
      );

  void _resetFields() {
    _eventNameController.clear();
    _descriptionController.clear();
    _noteController.clear();
    _addressController.clear();
    setState(() {
      _requestDate = null;
    });
  }
}

class _MyPainter extends CustomPainter {
  var avatarRadius = 60.0;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = MainColors.primary;

    const topLeft = Offset(0, 0);
    final bottomLeft = Offset(0, size.height * 0.25);
    final topRight = Offset(size.width, 0);
    final bottomRight = Offset(size.width, size.height * 0.25);

    final leftCurveControlPoint =
        Offset(size.width * 0.2, size.height - avatarRadius * 0.8);
    final rightCurveControlPoint = Offset(size.width - leftCurveControlPoint.dx,
        size.height - avatarRadius * 0.8);

    final avatarLeftPoint =
        Offset(size.width * 0.5 - avatarRadius + 5, size.height * 0.5);
    final avatarRightPoint =
        Offset(size.width * 0.5 + avatarRadius - 5, avatarLeftPoint.dy);

    final avatarTopPoint =
        Offset(size.width / 2, size.height / 2 - avatarRadius);

    final path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarTopPoint, radius: const Radius.circular(60.0))
      ..lineTo(size.width / 2, 0)
      ..close();

    final path2 = Path()
      ..moveTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          avatarRightPoint.dx, avatarRightPoint.dy)
      ..arcToPoint(avatarTopPoint,
          radius: const Radius.circular(60.0), clockwise: false)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
