// ignore_for_file: file_names, prefer_is_empty, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:bloodDonate/blocks/blood_request_block_provider.dart';
import 'package:bloodDonate/common/colors.dart';
import 'package:bloodDonate/models/BloodRequestModel.dart';
import 'package:bloodDonate/models/BloodRequestResponseModel.dart';
import 'package:bloodDonate/models/EventRequestModel.dart';
import 'package:bloodDonate/models/EventRequestResponseModel.dart';
import 'package:bloodDonate/ui/pages/BloodRequestDetail.dart';
import 'package:bloodDonate/ui/pages/PostAEvent.dart';
import 'package:bloodDonate/ui/pages/shimmerPages/shimmer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'allBloodRequestsPage.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homepage';

  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoadingBloodrequest = false;
  @override
  void initState() {
    setState(() {
      isLoadingBloodrequest = true;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Consumer<BloodRequestProvider>(builder: (context, block, child) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _headerImage(user?.photoURL),
              ),
              Positioned(
                top: 18,
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
                              height: 70,
                              child: Row(children: [
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        block.isLoading
                                            ? '0'
                                            : block.responseModel == null
                                                ? '0'
                                                : block.responseModel
                                                            .listOfBloodRequests ==
                                                        null
                                                    ? '0'
                                                    : '0' +
                                                        block
                                                            .responseModel
                                                            .listOfBloodRequests
                                                            .length
                                                            .toString(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(49, 39, 79, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 45),
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        block.isLoadingGetEvents
                                            ? '0'
                                            : block.eventResponseModel == null
                                                ? '0'
                                                : block.eventResponseModel
                                                            .listOfEventRequests ==
                                                        null
                                                    ? '0'
                                                    : '0' +
                                                        block
                                                            .eventResponseModel
                                                            .listOfEventRequests
                                                            .length
                                                            .toString(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(49, 39, 79, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 45),
                                      )),
                                ),
                              ]),
                            ),
                            Container(
                              height: 30,
                              child: Row(children: [
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Requests",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(49, 39, 79, 1),
                                            fontSize: 15),
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Events",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(49, 39, 79, 1),
                                            fontSize: 15),
                                      )),
                                ),
                              ]),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Positioned(
                  top: 180,
                  left: 10,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          //  minHeight: viewportConstraints.maxHeight,
                          ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Current Requests",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllBloodRequestsPage()),
                                        );
                                      },
                                      child: Text(
                                        "View All",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      )),
                                ),
                              ]),
                          Container(
                              // A fixed-height child.
                              height: 280.0,
                              margin: const EdgeInsets.only(
                                  top: 20.0, bottom: 20.0),
                              alignment: Alignment.center,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                // children:
                                //     createItemList(block.responseModel),
                                scrollDirection: Axis.horizontal,
                                itemCount: block.isLoading
                                    ? 3
                                    : block.responseModel.listOfBloodRequests ==
                                            null
                                        ? 1
                                        : block.responseModel
                                            .listOfBloodRequests.length,
                                itemBuilder: (context, index) {
                                  if (block.isLoading) {
                                    return buildBloodRequestShimmer();
                                  } else {
                                    if (block.responseModel
                                            .listOfBloodRequests ==
                                        null) {
                                      return noData();
                                    } else {
                                      final bloodRequest = block.responseModel
                                          .listOfBloodRequests[index];
                                      return BloodRequestItem(bloodRequest);
                                    }
                                  }
                                },
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Featured Events",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ),
                              ]),
                          Container(
                              // A fixed-height child.
                              height: 280.0,
                              margin: const EdgeInsets.only(
                                  top: 20.0, bottom: 20.0),
                              alignment: Alignment.center,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                // children: createFeaturedEventItemList(
                                //     block.eventResponseModel),
                                scrollDirection: Axis.horizontal,
                                itemCount: block.isLoadingGetEvents
                                    ? 3
                                    : block.eventResponseModel
                                                .listOfEventRequests ==
                                            null
                                        ? 1
                                        : block.eventResponseModel
                                            .listOfEventRequests.length,

                                itemBuilder: (context, index) {
                                  if (block.isLoadingGetEvents) {
                                    return buildEventRequestShimmer();
                                  } else {
                                    if (block.eventResponseModel
                                            .listOfEventRequests ==
                                        null) {
                                      return noData();
                                    } else {
                                      final eventRequest = block
                                          .eventResponseModel
                                          .listOfEventRequests[index];
                                      return EventRequestItem(eventRequest);
                                    }
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        }));
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

  Widget noData() {
    return Center(
      child: Container(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
    );
  }

  List<Widget> createItemList(BloodRequestResponceModel responseModel) {
    if (responseModel.listOfBloodRequests.length > 0) {
      List<Widget> widgetList = [];
      for (BloodRequestModel bloodRequestModel
          in responseModel.listOfBloodRequests) {
        widgetList.add(item(bloodRequestModel));
      }
      return widgetList;
    } else {
      return null;
    }
  }

  Widget BloodRequestItem(BloodRequestModel responseModel) {
    return item(responseModel);
  }

  Widget EventRequestItem(EventRequestModel eventRequestModel) {
    return featuredEventItem(eventRequestModel);
  }

  Widget buildBloodRequestShimmer() => Container(
        margin: const EdgeInsets.all(10),
        width: 300,
        height: 500,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Row(children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.grey[300],
                      child: Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[200],
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                  height: 70,
                  child: Column(children: [
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                  ])),
            ),
          ],
        ),
      );

  Widget buildEventRequestShimmer() => Container(
        margin: const EdgeInsets.all(10),
        width: 300,
        height: 500,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Row(children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.grey[300],
                      child: Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[200],
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                  height: 70,
                  child: Column(children: [
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300],
                              child: Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey[200],
                              )),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey[300],
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.grey[200],
                            )),
                      ]),
                    ),
                  ])),
            ),
          ],
        ),
      );

  Widget item(BloodRequestModel bloodRequestModel) {
    List<Widget> errorWidgetList = [];
    int errorCount = 0;

    if (errorWidgetList.isEmpty) {
      errorWidgetList.add(Text('No errors available yet.'));
    }
    return Container(
        margin: const EdgeInsets.all(10),
        width: 300,
        height: 500,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BloodRequestDetail(
                      bloodGroup: bloodRequestModel.bloodGroup,
                      requesterName: bloodRequestModel.requesterName,
                      addedTime: bloodRequestModel.addedTime,
                      numberOfUnits: bloodRequestModel.numberOfUnits,
                      address: bloodRequestModel.cityName,
                      medicalCenterName: bloodRequestModel.medicalCenterName,
                      contactNumber: bloodRequestModel.contactNumber)),
            );
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Row(children: [
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/user_avatar.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Text(
                                bloodRequestModel.requesterName,
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 70,
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
                                "Blood Group  - ",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                bloodRequestModel.bloodGroup,
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
                                          'assets/images/bloodUnit.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Number of units - ",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                bloodRequestModel.numberOfUnits ?? "",
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
                                "Address - ",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                  width: 148.0,
                                  child: Text(
                                    bloodRequestModel.cityName ??
                                        "Not Recorded",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )),
                            ]),
                          ),
                        ])),
                  ),
                ],
              )),
        ));
  }
}

List<Widget> createFeaturedEventItemList(
    EventRequestResponceModel responseModel) {
  if (responseModel.listOfEventRequests.length > 0) {
    List<Widget> widgetList = [];
    for (EventRequestModel eventRequestModel
        in responseModel.listOfEventRequests) {
      widgetList.add(featuredEventItem(eventRequestModel));
    }
    return widgetList;
  } else {
    return null;
  }
}

Widget featuredEventItem(EventRequestModel eventRequestModel) {
  List<Widget> errorWidgetList = [];
  int errorCount = 0;

  if (errorWidgetList.isEmpty) {
    errorWidgetList.add(Text('No errors available yet.'));
  }
  return Container(
    margin: const EdgeInsets.all(10),
    width: 300,
    height: 500,
    child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/feturedEvent.jpg'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                  height: 70,
                  child: Column(children: [
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            eventRequestModel.requestDate,
                            style: TextStyle(
                                color: Colors.red[300],
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            eventRequestModel.eventName,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
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
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          eventRequestModel.address,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 15),
                        ),
                      ]),
                    ),
                  ])),
            ),
          ],
        )),
  );
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
