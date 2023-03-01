// ignore_for_file: file_names, prefer_const_constructors

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
import 'package:provider/provider.dart';
import 'package:google_place/google_place.dart';
import 'package:geocoder/geocoder.dart';

class PostAEvent extends StatefulWidget {
  static const String routeName = '/postaevent';

  const PostAEvent();

  @override
  _PostAEventState createState() => _PostAEventState();
}

class _PostAEventState extends State<PostAEvent> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String _bloodType = 'A+';
  DateTime _requestDate;
  bool _isLoading = false;
  bool _isSelected = false;

  String _patientNameEmpty = "Please enter patient name";
  String _contactNumberEmpty = "Please enter contact number";
  String _addressEmpty = "Please enter address";
  String _requestDateEmpty = "Please enter request date";
  GooglePlace googlePlace;
  String lat;
  String long;
  List<AutocompletePrediction> predictions = [];
  bool _isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    String apiKey = "AIzaSyDBU32ihKNmFIEb6nS3nTNm6TwMpTdR9Eg";
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  void didChangeDependencies() {
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
    _eventNameController?.dispose();
    _descriptionController?.dispose();
    _addressController.dispose();
    _noteController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    const elementsSpacer = SizedBox(height: 16);

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Consumer<BloodRequestProvider>(
            builder: (context, bloodRequestProvider, child) {
          return Stack(children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          width: width,
                          child: Container(
                            child: _headerImage(user?.photoURL),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          left: 20,
                          right: 20,
                          child: Container(
                            width: 200,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 110,
                                        child: Row(children: [
                                          Expanded(
                                            child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/blood.png'),
                                                          fit: BoxFit.fill)),
                                                )),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            0.5,
                            Text(
                              "Post a Event",
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            0.7,
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(228, 54, 75, .1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: _eventNameField(),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _addressField()),
                                  Visibility(
                                    visible: _isVisible,
                                    maintainState: true,
                                    maintainAnimation: true,
                                    child: SizedBox(
                                      height: 200, // constrain height
                                      child: ListView.builder(
                                        itemCount: predictions == null
                                            ? 0
                                            : predictions.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.grey[300]),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                child: Icon(
                                                  Icons.pin_drop,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: predictions.length != 0
                                                  ? Text(predictions[index]
                                                      .description)
                                                  : Text(""),
                                              onTap: () {
                                                _addressController.text =
                                                    predictions[index]
                                                        .description;
                                                getCoordinates(
                                                    predictions[index]
                                                        .description);
                                                predictions.clear();
                                                setState(() {
                                                  _isVisible = false;
                                                });
                                                setState(() {
                                                  _isSelected = true;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      child: _requestDatePicker()),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _descriptionField()),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          0.9,
                          InkWell(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(13, 50, 77, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_eventNameController.text.trim() == null) {
                                  showtoast(_patientNameEmpty);
                                } else if (_descriptionController.text.trim() ==
                                    null) {
                                  showtoast(_contactNumberEmpty);
                                } else if (_addressController.text.trim() ==
                                    null) {
                                  showtoast(_addressEmpty);
                                } else if (_requestDate == null) {
                                  showtoast(_requestDateEmpty);
                                } else {}
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) - 5,
              left: (MediaQuery.of(context).size.width / 2) - 50,
              child: bloodRequestProvider.isLoading
                  ? Container(
                      height: 80,
                      width: 80,
                      child: SpinKitFadingCube(
                        color: Colors.deepPurple,
                        size: 70.0,
                      ))
                  : Container(),
            )
          ]);
        }),
      ),
    );
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
        textInputAction: TextInputAction.next,
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
        textInputAction: TextInputAction.next,
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
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        validator: (v) => Validators.required(v, 'Address'),
        decoration: InputDecoration(
          labelText: 'Address',
          fillColor: Colors.white,
          // border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontFamily: "Poppins",
        ),
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
        textInputAction: TextInputAction.next,
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
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light().copyWith(
                    primaryColor: const Color(0xFF4A5BF6),
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.red)
                            .copyWith(
                                secondary:
                                    const Color(0xFF4A5BF6)) //selection color
                    //dialogBackgroundColor: Colors.white,//Background color
                    ),
                child: child,
              );
            },
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
