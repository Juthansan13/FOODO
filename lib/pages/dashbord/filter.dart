import 'package:flutter/material.dart';
import 'package:firebase/color.dart';

void showFoodFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To allow full height
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Icon
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 28),
              ),
            ),
            const SizedBox(height: 10),

            // Title
            const Text(
              'Food filter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Item Added By
            const Text(
              'Eating Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterOption('Breakfast', true),
                _buildFilterOption('Lunch', false),
                _buildFilterOption('Dinner', false),
              ],
            ),
            const SizedBox(height: 15),

            // Item Availability
            const Text(
              'Item Availability',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterOption('All', true),
                _buildFilterOption('Free', false),
                _buildFilterOption('Buy', false),
              ],
            ),
            const SizedBox(height: 15),

            // Maximum Distance
            const Text(
              'Maximum Distance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDistanceOption('0.5 km',true),
                _buildDistanceOption('1 km',false),
                _buildDistanceOption('2 km',false),
                _buildDistanceOption('5 km',false),
              ],
            ),
            const SizedBox(height: 15),
/*
            // Sort By
            const Text(
              'Sort by',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Radio(value: 'Newest', groupValue: 'Closest', onChanged: (value) {}),
                const Text('Newest'),
                Radio(value: 'Closest', groupValue: 'Closest', onChanged: (value) {}),
                const Text('Closest'),
              ],
            ),
            const SizedBox(height: 15),
*/
            // Location
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLocationOption('Home', true),
                _buildLocationOption('Current location', false),
              ],
            ),
            const SizedBox(height: 20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Helper Widget for Filter Options
Widget _buildFilterOption(String label, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? primaryColor : Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Helper Widget for Distance Options
Widget _buildDistanceOption(String label,bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label),
  );
}

// Helper Widget for Location Options
Widget _buildLocationOption(String label, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.grey[400] : Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
