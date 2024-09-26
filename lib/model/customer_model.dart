class CustomerModel {
  String id; // Unique identifier for the customer
  String name;
  String image; // URL or path to the customer's image
  String phone;
  String email;
  String address;

  CustomerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    required this.address,
  });

  // Factory method to create a Customer from Firestore document data
  factory CustomerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CustomerModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
    );
  }

  // Method to convert a Customer instance to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
