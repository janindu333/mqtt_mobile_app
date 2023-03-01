import 'package:bloodDonate/blocks/BlocEventStateBase.dart';
import 'package:bloodDonate/blocks/BlocEventStateBase.dart';

abstract class BloodRequestEvent extends BlocEvent {
  BloodRequestEvent();
}

class bloodRequestEventData extends BloodRequestEvent {
  bloodRequestEventData({String bloodRequestId}) : super();
}
