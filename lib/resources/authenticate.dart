import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloodDonate/models/BloodRequestModel.dart';
import 'package:bloodDonate/models/EventRequestModel.dart';
import 'package:bloodDonate/models/EventRequestResponseModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:bloodDonate/blocks/BloodRequestBloc.dart';
import 'package:bloodDonate/models/BloodRequestResponseModel.dart';
import 'package:bloodDonate/models/LoginResponseModel.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<String> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      //     await firestore.collection(USERS).doc(result.user?.uid ?? '').get();
      // User? user;
      // if (documentSnapshot.exists) {
      // //  user = User.fromJson(documentSnapshot.data() ?? {});
      // }
      // return user;
      return "Success";
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint(exception.toString() + '$s');
      return exception.message.toString();
      switch ((exception).code) {
        // case 'invalid-email':
        //   return 'Email address is malformed.';
        // case 'wrong-password':
        //   return 'Wrong password.';
        // case 'user-not-found':
        //   return 'No user corresponding to the given email address.';
        // case 'user-disabled':
        //   return 'This user has been disabled.';
        // case 'too-many-requests':
        //   return 'Too many attempts to sign in as this user.';
      }
      //  return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      return e.toString();
      debugPrint(e.toString() + '$s');
      // return 'Login failed, Please try again.';
    }
  }

  static Future<String> signUpWithEmailAndPassword(
      String email, String password, String bloodType) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint("SDDDD");
      final users = FirebaseFirestore.instance.collection('users');
      await users.doc(userCredential.user.uid).set({
        'bloodType': bloodType,
        'isAdmin': false,
      }, SetOptions(merge: true));
      return "sucess";
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint(exception.toString() + '$s');
      if (exception.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (exception.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e, s) {
      debugPrint(e.toString() + '$s');
      return e.toString();
      // return 'Login failed, Please try again.';
    }
  }

  static Future<BloodRequestResponceModel> fetchBloodRequestData() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> bloodRequests =
        FirebaseFirestore.instance
            .collection('blood_requests')
            .where('isFulfilled', isEqualTo: false)
            .orderBy('requestDate')
            .limit(30)
            .snapshots();

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('blood_requests');

    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map> listOfBloodRequests = [];
    // String jsonTags = jsonEncode(allData);
    // return BloodRequestResponceModel.fromJson(jsonTags);
    List<BloodRequestModel> allBloodrequestData = new List<BloodRequestModel>();
    BloodRequestResponceModel bloodRequestResponceModel =
        new BloodRequestResponceModel();
    for (var i = 0; i < allData.length; i++) {
      // String jsonTags = json.encode(allData[i]);
      // listOfBloodRequests.add(allData[i]);

      Map<String, dynamic> jsonData = allData[i];
      BloodRequestModel bloodRequestModel = new BloodRequestModel();

      for (var entry in jsonData.entries) {
        switch (entry.key) {
          case "patientName":
            {
              bloodRequestModel.requesterName = entry.value;
            }
            break;

          case "numberOfUnits":
            {
              bloodRequestModel.numberOfUnits = entry.value;
            }
            break;

          case "uid":
            {
              bloodRequestModel.requesterId = entry.value;
            }
            break;

          case "requestDate":
            {
              bloodRequestModel.addedTime = entry.value.toString();
            }
            break;

          case "estimatedDistance":
            {
              bloodRequestModel.estimatedDistance = entry.value;
            }
            break;
          case "contactNumber":
            {
              bloodRequestModel.contactNumber = entry.value;
            }
            break;
          case "cityName":
            {
              bloodRequestModel.cityName = entry.value;
            }
            break;
          case "medicalCenterName":
            {
              bloodRequestModel.medicalCenterName = entry.value;
            }
            break;
          case "note":
            {
              bloodRequestModel.age = entry.value;
            }
            break;
          case "bloodType":
            {
              bloodRequestModel.bloodGroup = entry.value;
            }
            break;
        }
      }

      allBloodrequestData.add(bloodRequestModel);
      bloodRequestResponceModel.listOfBloodRequests = allBloodrequestData;
      bloodRequestResponceModel.error = null;
      bloodRequestResponceModel.errorCode = 0;
      bloodRequestResponceModel.message = "success";
      bloodRequestResponceModel.success = true;
    }

    return bloodRequestResponceModel;
  }

  static Future<BloodRequestResponceModel> submitBloodRequest(
      String patientName,
      String contactNumber,
      String cityName,
      String medicalCenterName,
      String bloodType,
      String requestDate,
      String numberOfUnits,
      String note) async {
    BloodRequestResponceModel bloodRequestResponceModel =
        new BloodRequestResponceModel();
    try {
      final user = FirebaseAuth.instance.currentUser;
      final requests = FirebaseFirestore.instance.collection('blood_requests');
      await requests.add({
        'uid': user.uid,
        'submittedBy': user.displayName,
        'patientName': patientName,
        'bloodType': bloodType,
        'contactNumber': contactNumber,
        'cityName': cityName,
        'medicalCenterName': medicalCenterName,
        'note': "",
        'submittedAt': DateTime.now(),
        'requestDate': requestDate,
        'numberOfUnits': numberOfUnits,
        'isFulfilled': false,
      });
      // _resetFields();
      // Fluttertoast.showToast(msg: 'Request successfully Submitted');
      // Navigator.pop(context);
      bloodRequestResponceModel.error = null;
      bloodRequestResponceModel.errorCode = 0;
      bloodRequestResponceModel.message = "success";
      bloodRequestResponceModel.success = true;
    } catch (e) {
      bloodRequestResponceModel.error = 1;
      bloodRequestResponceModel.errorCode = 1;
      bloodRequestResponceModel.message =
          "Something went wrong, please try again";
      bloodRequestResponceModel.success = false;
      // Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      // setState(() => _isLoading = false);
    }
    return bloodRequestResponceModel;
  }

  static Future<EventRequestResponceModel> fetchEventRequestData() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('event_requests');

    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map> listOfEventRequests = [];
    // String jsonTags = jsonEncode(allData);
    // return BloodRequestResponceModel.fromJson(jsonTags);
    List<EventRequestModel> allEventrequestData = new List<EventRequestModel>();
    EventRequestResponceModel eventRequestResponceModel =
        new EventRequestResponceModel();
    for (var i = 0; i < allData.length; i++) {
      Map<String, dynamic> jsonData = allData[i];
      EventRequestModel eventRequestModel = new EventRequestModel();

      for (var entry in jsonData.entries) {
        switch (entry.key) {
          case "address":
            {
              eventRequestModel.address = entry.value;
            }
            break;

          case "description":
            {
              eventRequestModel.description = entry.value;
            }
            break;

          case "eventName":
            {
              eventRequestModel.eventName = entry.value;
            }
            break;

          case "requestDate":
            {
              eventRequestModel.requestDate = entry.value.toString();
            }
            break;

          case "submittedBy":
            {
              eventRequestModel.submittedBy = entry.value;
            }
            break;
          case "uid":
            {
              eventRequestModel.uid = entry.value;
            }
            break;
        }
      }

      allEventrequestData.add(eventRequestModel);
      eventRequestResponceModel.listOfEventRequests = allEventrequestData;
      eventRequestResponceModel.error = null;
      eventRequestResponceModel.errorCode = 0;
      eventRequestResponceModel.message = "success";
      eventRequestResponceModel.success = true;
    }

    return eventRequestResponceModel;
  }

  static Future<BloodRequestResponceModel> submitEventBloodRequest(
      String eventName,
      String description,
      String address,
      String requestDate,
      String lattitude,
      String longitude) async {
    BloodRequestResponceModel bloodRequestResponceModel =
        new BloodRequestResponceModel();
    try {
      final user = FirebaseAuth.instance.currentUser;
      final requests = FirebaseFirestore.instance.collection('event_requests');
      await requests.add({
        'uid': user.uid,
        'submittedBy': user.displayName,
        'eventName': eventName,
        'description': description,
        'address': address,
        'requestDate': requestDate,
        'lattitude': lattitude,
        'longitude': longitude
      });
      // _resetFields();
      // Fluttertoast.showToast(msg: 'Request successfully Submitted');
      // Navigator.pop(context);
      bloodRequestResponceModel.error = null;
      bloodRequestResponceModel.errorCode = 0;
      bloodRequestResponceModel.message = "success";
      bloodRequestResponceModel.success = true;
    } catch (e) {
      bloodRequestResponceModel.error = 1;
      bloodRequestResponceModel.errorCode = 1;
      bloodRequestResponceModel.message =
          "Something went wrong, please try again";
      bloodRequestResponceModel.success = false;
      // Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      // setState(() => _isLoading = false);
    }
    return bloodRequestResponceModel;
  }

  static logout() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  static resetPassword(String emailAddress) async =>
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress);
}
