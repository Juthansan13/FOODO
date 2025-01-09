import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Foodpage extends StatelessWidget {
  final String productTitle;

  const Foodpage({super.key, required this.productTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Page'),
      ),
      body: FutureBuilder<User?>(
        future: Future.value(FirebaseAuth.instance.currentUser), // Wrap currentUser in Future.value
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('No user signed in.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Display the user's name or email
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'User: ${user.displayName ?? 'Anonymous'}', // Display name or fallback
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Display the product title or donation details
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Product: $productTitle',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Add the CarouselSlider for images here (if any)
                CarouselSlider(
                  items: const [], // Add your image URLs here
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),
                const SizedBox(height: 10),
                // More product or donation details can go here
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item Details: $productTitle', // Replace with actual product or donation details
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
