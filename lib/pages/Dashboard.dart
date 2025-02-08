import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/dashbord/Foodpage.dart';
import 'package:firebase/pages/dashbord/product.dart';
import 'package:firebase/color.dart';

class DashboardPage extends StatelessWidget {
  final String? searchQuery;

  const DashboardPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: searchQuery != null
              ? _buildSearchAppBar(context, searchQuery!)
              : _buildDefaultAppBar(),
        ),
        body: Column(
          children: [
            // Buttons below AppBar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    context,
                    Icons.filter_alt,
                    "Filter",
                    () => showFoodFilterSheet(context), // Open filter modal
                  ),
                  _buildActionButton(
                    context,
                    Icons.free_breakfast,
                    "Free",
                    () => _navigateToFreeProductsPage(context),
                  ),
                  _buildActionButton(
                    context,
                    Icons.shopping_cart,
                    "Buy",
                    () => _navigateToBuyProductsPage(context),
                  ),
                ],
              ),
            ),
            // Main content below buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
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
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.97,
                      ),
                      itemCount: donations.length,
                      itemBuilder: (context, index) {
                        final product = Product.fromFirestore(donations[index]);

                        return Container(
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
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
                                child: product.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4)),
                                        child: Image.network(
                                          product.image,
                                          height: 100,
                                          width: 175,
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
                                              child: Icon(Icons.error, color: Colors.red),
                                            );
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.image_not_supported, size: 100),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Quantity: ${product.description}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF555555),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product.type,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF555555),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, right: 4, bottom: 2),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    product.timeAgo(),
                                    style: const TextStyle(
                                      fontSize: 8,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAppBar(BuildContext context, String query) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          query,
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
    );
  }

  Widget _buildDefaultAppBar() {
    return const Text(
      'FOODO',
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: primaryColor),
      label: Text(
        label,
        style: const TextStyle(color: primaryColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
    );
  }

  void _navigateToFreeProductsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreeProductsPage(searchQuery: searchQuery),
      ),
    );
  }

  void _navigateToBuyProductsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuyProductsPage(searchQuery: searchQuery),
      ),
    );
  }

  void showFoodFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Center(
        child: Text("Filter options go here"),
      ),
    );
  }
}

// Free Products Page
class FreeProductsPage extends StatelessWidget {
  final String? searchQuery;

  const FreeProductsPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Free Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: searchQuery != null
            ? FirebaseFirestore.instance
                .collection('donations')
                .where('type', isEqualTo: 'free')
                .where('item_details', isGreaterThanOrEqualTo: searchQuery)
                .where('item_details', isLessThanOrEqualTo: '${searchQuery!}\uf8ff')
                .orderBy('item_details')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('donations')
                .where('type', isEqualTo: 'free')
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
            return const Center(child: Text('No free products available.'));
          }

          final donations = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.97,
            ),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final product = Product.fromFirestore(donations[index]);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
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
                      child: product.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              child: Image.network(
                                product.image,
                                height: 100,
                                width: 175,
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
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quantity: ${product.description}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF555555),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.type,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF555555),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 4, bottom: 2),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          product.timeAgo(),
                          style: const TextStyle(
                            fontSize: 8,
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
    );
  }
}

// Buy Products Page
class BuyProductsPage extends StatelessWidget {
  final String? searchQuery;

  const BuyProductsPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Buy Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: searchQuery != null
            ? FirebaseFirestore.instance
                .collection('donations')
                .where('type', isEqualTo: 'buy')
                .where('item_details', isGreaterThanOrEqualTo: searchQuery)
                .where('item_details', isLessThanOrEqualTo: '${searchQuery!}\uf8ff')
                .orderBy('item_details')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('donations')
                .where('type', isEqualTo: 'buy')
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
            return const Center(child: Text('No buy products available.'));
          }

          final donations = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.8,
            ),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final product = Product.fromFirestore(donations[index]);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
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
                      child: product.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              child: Image.network(
                                product.image,
                                height: 120,
                                width: 175,
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
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quantity: ${product.description}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF555555),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 4, bottom: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.type,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF555555),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 4, bottom: 2),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          product.timeAgo(),
                          style: const TextStyle(
                            fontSize: 8,
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
    );
  }
}