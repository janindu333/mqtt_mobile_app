// ignore_for_file: file_names

import 'package:bloodDonate/blocks/BlocBase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocEvent extends Object {}

abstract class BlocState extends Object {}

abstract class BlocEventStateBase<BlocEvent, BlocState> implements BlocBase {
  final PublishSubject<BlocEvent> _eventController =
      PublishSubject<BlocEvent>();
  final BehaviorSubject<BlocState> _stateController =
      BehaviorSubject<BlocState>();

  ///
  /// To be invoked to emit an event
  ///
  Function(BlocEvent) get emitEvent => _eventController.sink.add;

  ///
  /// Current/New state
  ///
  Stream<BlocState> get state => _stateController.stream;

  ///
  /// External processing of the event
  ///
  Stream<BlocState> eventHandler(BlocEvent event, BlocState currentState);

  ///
  /// initialState
  ///
  final BlocState initialState;

  //
  // Constructor
  //
  BlocEventStateBase({
    @required this.initialState,
  }) {
    //
    // For each received event, we invoke the [eventHandler] and
    // emit any resulting newState
    //
    _eventController.listen((BlocEvent event) {
      BlocState currentState;
      if (!_stateController.hasValue) {
        currentState = initialState;
      } else {
        currentState = _stateController.value;
      }
      eventHandler(event, currentState).forEach((BlocState newState) {
        _stateController.sink.add(newState);
      });
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
