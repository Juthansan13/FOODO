import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/dashbord/Foodpage.dart';
import 'package:firebase/pages/dashbord/product.dart';

class DashboardPage extends StatelessWidget {
  final String? searchQuery;

  const DashboardPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: searchQuery != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchQuery!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back to Search page
                      },
                    ),
                  ],
                )
              : const Text(
                  'FOODO',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: searchQuery != null
                ? FirebaseFirestore.instance
                    .collection('donations')
                    .where('item_details', isGreaterThanOrEqualTo: searchQuery)
                    .where('item_details', isLessThanOrEqualTo: '${searchQuery!}\uf8ff')
                    .orderBy('item_details')
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('donations')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final donations = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final data = donations[index].data() as Map<String, dynamic>;
                  final product = Product.fromFirestore(donations[index]);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Foodpage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            child: product.image.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: Image.network(
                                      product.image,
                                      height: 120,
                                      width: 170,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red));
                                      },
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported, size: 100),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Quantity: ${product.description}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF555555),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              product.timeAgo(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
