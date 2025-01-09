import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'product.dart';
import 'package:firebase/color.dart';
import 'package:firebase/pages/chat/message.dart'; // Import the message page

class Foodpage extends StatefulWidget {
  final Product product;

  const Foodpage({super.key, required this.product});

  @override
  _FoodpageState createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  bool isRequested = false; // To track if the request button is toggled
  @override
  Widget build(BuildContext context) {
         // Assuming 'amount' is a String and it might be '0' or other value.
    final donationType = widget.product.amount == '0' ? 'Free' : 'Buy';
    final amount = widget.product.amount != '0' ? widget.product.amount : null;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            'Details',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                final shareText = 'Check out this donation: ${widget.product.title}';
                Share.share(shareText, subject: 'Donation Details');
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // Implement like functionality
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // CarouselSlider
                CarouselSlider(
                  items: widget.product.additionalImages.map((imageUrl) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),

                // Food Title
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                  // Donation Type and Amount (if applicable)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    donationType == 'Free'
                        ? 'This donation is free'
                        : 'Price: LKR $amount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                // Product Details
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildInfoRow(Icons.person_2, "", widget.product.email),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.person_2, "Quantity", widget.product.description),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.access_time, "Pickup Time", widget.product.pickuptime),
                      const SizedBox(height: 10),
                      _buildLocationRow(context, widget.product),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Toggle the request/cancel button
                      isRequested = !isRequested;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRequested ? Colors.grey : primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isRequested ? "Cancel" : "Request",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to MessagePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(email: '',), // Navigate to Message Page
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Message button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 14),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, Product product) {
    return Row(
      children: [
        const Icon(Icons.gps_fixed, color: primaryColor, size: 16),
        const SizedBox(width: 5),
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            product.location, // Directly use product.location
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.blue, size: 18),
          onPressed: () {
            // Implement GPS tracker functionality
          },
        ),
      ],
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'product.dart';
import 'package:firebase/color.dart';


class Foodpage extends StatelessWidget {
  final Product product;

  const Foodpage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final shareText = 'Check out this donation: ${product.title}';
              Share.share(shareText, subject: 'Donation Details');
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Implement like functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add the CarouselSlider here
              CarouselSlider(
                items: product.additionalImages.map((imageUrl) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                 // width: 300,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),

              // Container holding product details
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildInfoRow(Icons.person_2, "Quantity", product.description),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.access_time, "Pickup Time", product.pickuptime),
                    const SizedBox(height: 10),
                    _buildLocationRow(context, product),
                    _buildInfoRow(Icons.access_time, "Pickup Time", product.pickuptime),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Implement call functionality
                  print('Request');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Call button color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Request",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Spacing between buttons
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Implement message functionality
                  print('Message button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Message button color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Message",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 16),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, Product product) {
    return Row(
      children: [
        const Icon(Icons.gps_fixed, color: primaryColor, size: 16),
        const SizedBox(width: 5),
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            product.location, // Directly use product.location
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.blue),
          onPressed: () {
            // Implement GPS tracker functionality
          },
        ),
      ],
    );
  }
}*/
