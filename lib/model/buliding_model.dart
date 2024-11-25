import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  String id;
  String prospectName;
  String projectName;
  String projectAddress;
  String floorNo;
  String appointmentSize;
  int persqftPrice;
  dynamic totalUnitPrice;
  dynamic carParking;
  dynamic unitCost;
  dynamic totalCost;
  String? image; // New image field
  DateTime? createDateTime; // Auto-generated create time
  DateTime? updateDateTime; // Auto-updated when modified
  String? status; // New field for status ('available' or 'booked')

  BuildingModel({
    required this.id,
    required this.prospectName,
    required this.projectName,
    required this.projectAddress,
    required this.floorNo,
    required this.appointmentSize,
    required this.persqftPrice,
    required this.totalUnitPrice,
    this.carParking,
    this.unitCost,
    required this.totalCost,
    this.image,
    this.createDateTime,
    this.updateDateTime,
    this.status, // Include status in the constructor
  });

  // Convert from Firestore document
  factory BuildingModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return BuildingModel(
      id: documentId,
      prospectName: data['prospectName'] ?? 'Unknown',
      projectName: data['projectName'] ?? 'Unknown',
      projectAddress: data['projectAddress'] ?? 'Unknown',
      floorNo: data['floorNo'] ?? 'N/A',
      appointmentSize: data['appointmentSize'] ?? 'N/A',
      persqftPrice: data['persqftPrice'] != null ? data['persqftPrice'] as int : 0,
      totalUnitPrice: data['totalUnitPrice'] ?? 0,
      carParking: data['carParking'] ?? 0,
      unitCost: data['unitCost'] ?? 0,
      totalCost: data['totalCost'] ?? 0,
      image: data['image'],
      createDateTime: data['createDateTime'] != null
          ? (data['createDateTime'] as Timestamp).toDate()
          : DateTime.now(),
      updateDateTime: data['updateDateTime'] != null
          ? (data['updateDateTime'] as Timestamp).toDate()
          : null,
      status: data['status'] ?? 'available',
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
      'persqftPrice': persqftPrice,
      'totalUnitPrice': totalUnitPrice,
      'carParking': carParking,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'image': image,
      'createDateTime': createDateTime,
      'updateDateTime': updateDateTime ?? FieldValue.serverTimestamp(), // Auto-updated
      'status': status, // Include status in the Firestore document
    };
  }
}
