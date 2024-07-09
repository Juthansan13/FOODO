import 'package:firebase/color.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Set the background color here
          automaticallyImplyLeading: false,
          centerTitle: true, // Center the title
          title: const Text(
            'FOODO',
            style: TextStyle(
              color: Colors.white, // Set the text color here if needed
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _buildDashboardItem(context, 'Location', Icons.location_on, () {
                      // Navigate to location screen or action
                    }),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDashboardItem(context, 'Category', Icons.category, () {
                      // Navigate to category screen or action
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Available Food',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: _buildFoodCard(context, 'Food Item 1', 'Description of Food Item 1', () {
                        // Navigate to food details for Food Item 1
                      }),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildFoodCard(context, 'Food Item 2', 'Description of Food Item 2', () {
                        // Navigate to food details for Food Item 2
                      }),
                    ),
                  ],
                ),
              ),
              // Add more food cards as needed
            ],

          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, String title, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
