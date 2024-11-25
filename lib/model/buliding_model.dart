import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  String id;
  String prospectName;
  String projectName;
  String projectAddress;
  String floorNo;
  String appointmentSize;
  int persqftPrice;
  dynamic totalUnitPrice;  // Can be dynamic (int, double, or null)
  dynamic carParking;      // Can be dynamic (int, bool, or null)
  dynamic unitCost;        // Can be dynamic (int, double, or null)
  dynamic totalCost;       // Can be dynamic (int, double, or null)
  String? image;           // Optional, for image URL
  DateTime? createDateTime;  // Optional DateTime for creation timestamp
  DateTime? updateDateTime;  // Optional DateTime for last update timestamp
  String status;             // Optional, default could be 'available'

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
    this.status = 'available',  // Default value for status
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
      totalUnitPrice: data['totalUnitPrice'] ?? 0,  // Ensure default if null
      carParking: data['carParking'],  // Optional, could be null or any type
      unitCost: data['unitCost'],      // Optional, could be null or any type
      totalCost: data['totalCost'] ?? 0,  // Ensure default if null
      image: data['image'],
      createDateTime: data['createDateTime'] != null
          ? (data['createDateTime'] as Timestamp).toDate()
          : DateTime.now(),  // Default to current time if null
      updateDateTime: data['updateDateTime'] != null
          ? (data['updateDateTime'] as Timestamp).toDate()
          : null,
      status: data['status'] ?? 'available',  // Default to 'available' if null
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
      'createDateTime': createDateTime != null ? Timestamp.fromDate(createDateTime!) : null,
      'updateDateTime': updateDateTime != null ? Timestamp.fromDate(updateDateTime!) : FieldValue.serverTimestamp(),  // Use server timestamp if null
      'status': status,
    };
  }
}
