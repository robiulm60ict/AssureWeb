import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  String id;
  String prospectName;
  String projectName;
  String projectAddress;
  String floorNo;
  String appointmentSize;
  int perSftPrice;
  double totalUnitPrice;
  double? carParking;
  double? unitCost;
  double totalCost;
  String? image; // New image field
  DateTime? createDateTime; // Auto-generated create time
  DateTime? updateDateTime; // Auto-updated when modified

  BuildingModel({
    required this.id,
    required this.prospectName,
    required this.projectName,
    required this.projectAddress,
    required this.floorNo,
    required this.appointmentSize,
    required this.perSftPrice,
    required this.totalUnitPrice,
    this.carParking,
    this.unitCost,
    required this.totalCost,
    this.image,
     this.createDateTime,
    this.updateDateTime,
  });

  // Convert from Firestore document
  factory BuildingModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return BuildingModel(
      id: documentId,
      prospectName: data['prospectName'],
      projectName: data['projectName'],
      projectAddress: data['projectAddress'],
      floorNo: data['floorNo'],
      appointmentSize: data['appointmentSize'],
      perSftPrice: data['perSftPrice'],
      totalUnitPrice: data['totalUnitPrice'],
      carParking: data['carParking'],
      unitCost: data['unitCost'],
      totalCost: data['totalCost'],
      image: data['image'],
      createDateTime: data['createDateTime'] != null
          ? (data['createDateTime'] as Timestamp).toDate()
          : DateTime.now(), // Default to current time if null
      updateDateTime: data['updateDateTime'] != null
          ? (data['updateDateTime'] as Timestamp).toDate()
          : null, // Nullable updateDateTime
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'prospectName': prospectName,
      'projectName': projectName,
      'projectAddress': projectAddress,
      'floorNo': floorNo,
      'appointmentSize': appointmentSize,
      'perSftPrice': perSftPrice,
      'totalUnitPrice': totalUnitPrice,
      'carParking': carParking,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'image': image,
      'createDateTime': createDateTime,
      'updateDateTime': updateDateTime ?? FieldValue.serverTimestamp(), // Auto-updated
    };
  }
}
