import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DonationDetailPage extends StatelessWidget {
  final Map<String, dynamic> donation;

  const DonationDetailPage({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(donation['item_details']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display images using CarouselSlider if there are multiple images
            if (donation['images'] != null && donation['images'].isNotEmpty)
              CarouselSlider(
                items: donation['images'].map<Widget>((imageUrl) {
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
                'Item Details: ${donation['item_details']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Display the number of persons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Serves: ${donation['num_persons']} persons',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Display pickup location
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Location: ${donation['pickup_location']}',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Display pickup date and time
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Date: ${donation['pickup_date']}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Time: ${donation['pickup_time']}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
