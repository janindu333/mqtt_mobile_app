import 'dart:async';

import 'package:bloodDonate/models/BloodRequestModel.dart';
import 'package:bloodDonate/models/BloodRequestResponseModel.dart';
import 'package:bloodDonate/resources/authenticate.dart';

import 'BlocBase.dart';

class BloodRequestBloc extends BlocBase {
  final streamController = StreamController<BloodRequestResponceModel>();
  List<BloodRequestModel> listOfBloodRequests;

  Stream<BloodRequestResponceModel> get bloodRequestsData =>
      streamController.stream;

  void fetchBloodRequestData() async {}

  @override
  void dispose() {
    streamController.close();
  }
}
