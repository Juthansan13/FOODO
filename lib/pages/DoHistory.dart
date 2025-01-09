import 'package:firebase/pages/dashbord/Foodpage.dart';
import 'package:firebase/pages/dashbord/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/color.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DoHistoryState();
}

class _DoHistoryState extends State<DonationHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteDonation(String donationId) async {
    await _firestore.collection('donations').doc(donationId).delete();
  }

  void _editDonation(String donationId, Map<String, dynamic> currentData) {
    // Navigate to the edit page, passing the current data
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Donation History',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('donations').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No donations found', style: TextStyle(fontSize: 20)),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                return ListTile(
                  leading: (data['images'] != null && data['images'].isNotEmpty)
                      ? Image.network(data['images'][0], width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(data['item_details'] ?? 'No title'),
                  subtitle: Text('Pickup: ${data['pickup_date'] ?? 'No date'} at ${data['pickup_time'] ?? 'No time'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editDonation(doc.id, data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDonation(doc.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    try {
                      // Convert Firestore data to a Product object
                      Product product = Product.fromFirestore(doc);

                      // Navigate to the Foodpage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Foodpage(product: product),
                        ),
                      );
                    } catch (e) {
                      // Handle the error, such as showing an error message
                      print('Error converting data to Product: $e');
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
