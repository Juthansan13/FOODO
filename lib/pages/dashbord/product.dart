import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Product {
  final String title;
  final String description;
  final String location;
  final String pickuptime;
  final List<String> additionalImages;
  final String image; // First image as the main image
  final Color color; // Color for UI representation
  final int id; // Unique identifier
  final DateTime timestamp;
  final int amount; // Timestamp as a DateTime object
  final String type;
  final String email;
  final String name;

  Product({
    required this.title,
    required this.description,
    required this.location,
    required this.pickuptime,
    required this.additionalImages,
    required this.image,
    required this.color,
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.type,
    required this.email,
    required this.name,
  });

  // Factory constructor to create a Product from Firestore data
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Product(
      name: data ['user_name'] ?? 'no name',
      email: data['user_email'] ?? 'no name',
      title: data['item_details'] ?? 'No Title',
      description: (data['num_persons'] as int?)?.toString() ?? 'No Description',
      location: data['pickup_location'] ?? '',
      pickuptime: data['pickup_time'] ?? '',
      additionalImages: List<String>.from(data['images'] ?? []),
      image: data['images'] != null && data['images'].isNotEmpty ? data['images'][0] : '',
      color: Colors.pink, // Use a default or dynamic color if needed
      id: int.tryParse(data['id']?.toString() ?? '0') ?? 0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handling timestamp properly
      amount: int.tryParse(data['amount']?.toString() ?? '0') ?? 0,
      type: data['type'] ?? 'No type',
    );
  }

  //get amount => null;

  // Method to calculate how long ago the donation was made
  String timeAgo() {
    return timeago.format(timestamp);
  }
}
