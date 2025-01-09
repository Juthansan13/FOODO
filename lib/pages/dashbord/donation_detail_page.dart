import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DonationDetailPage extends StatelessWidget {
  final Map<String, dynamic> donation;

  const DonationDetailPage({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    // Safely access the 'images' key and check if it's not null or empty
    final images = donation['images'];
    final itemDetails = donation['item_details'] ?? 'No item details available';
    final numPersons = donation['num_persons'] ?? 'N/A';
    final pickupLocation = donation['pickup_location'] ?? 'Not provided';
    final pickupDate = donation['pickup_date'] ?? 'Not specified';

    return Scaffold(
      appBar: AppBar(
        title: Text(itemDetails), // Display item details as the title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display images using CarouselSlider if there are multiple images
            if (images != null && images.isNotEmpty)
              CarouselSlider(
                items: images.map<Widget>((imageUrl) {
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
            const SizedBox(height: 10),

            // Display item details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Item Details: $itemDetails',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Display the number of persons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Serves: $numPersons persons',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Display pickup location
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Location: $pickupLocation',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Display pickup date and time
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Date: $pickupDate',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
