class BloodRequestModel {
  String requesterName;
  String requesterId;
  String addedTime;
  String estimatedDistance;
  String contactNumber;
  String age;
  String bloodGroup;
  String numberOfUnits;
  String cityName;
  String medicalCenterName;

  BloodRequestModel(
      {this.requesterName,
      this.requesterId,
      this.addedTime,
      this.estimatedDistance,
      this.age,
      this.bloodGroup,
      this.numberOfUnits,
      this.cityName,
      this.medicalCenterName,
      this.contactNumber});

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
        requesterName: json['requesterName'],
        numberOfUnits: json['numberOfunits'],
        requesterId: json['requesterId'],
        addedTime: json['addedTime'],
        estimatedDistance: json['estimatedDistance'],
        age: json['age'],
        bloodGroup: json['bloodGroup'],
        cityName: json['address'],
        medicalCenterName: json['medicalCenterName'],
        contactNumber: json['contactNumber']);
  }
}
