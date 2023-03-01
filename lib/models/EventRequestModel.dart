class EventRequestModel {
  String address;
  String description;
  String eventName;
  String requestDate;
  String submittedBy;
  String uid;

  EventRequestModel(
      {this.address,
      this.description,
      this.eventName,
      this.requestDate,
      this.submittedBy,
      this.uid});

  factory EventRequestModel.fromJson(Map<String, dynamic> json) {
    return EventRequestModel(
        address: json['address'],
        description: json['description'],
        eventName: json['eventName'],
        requestDate: json['requestData'],
        submittedBy: json['submittedBy'],
        uid: json['uid']);
  }
}
