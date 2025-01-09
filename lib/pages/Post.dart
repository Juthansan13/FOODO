import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _itemDetailsController = TextEditingController();
  final TextEditingController _numPersonsController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<XFile> _imageFiles = [];

  String _selectedPickupDate = 'Today';
  String _selectedPickupTime = '7am - 9am';
  String _selectedType = 'Free';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a loading flag to show a loading indicator
  bool _isLoading = false;

  // Function to save donation data
  Future<void> _saveDonation() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Get current user email
      User? user = _auth.currentUser;
      String userEmail = user != null ? user.email ?? 'Unknown' : 'Unknown';

      List<String> imageUrls = [];
      for (XFile imageFile in _imageFiles) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String imageUrl = await _uploadImage(imageFile, fileName);
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        }
      }

      // Prepare donation data
      final donationData = {
        'pickup_location': _pickupAddressController.text,
        'item_details': _itemDetailsController.text,
        'num_persons': int.parse(_numPersonsController.text),
        'pickup_date': _selectedPickupDate,
        'pickup_time': _selectedPickupTime,
        'type': _selectedType == 'Buy' ? 'buy' : 'free',
        'amount': _selectedType == 'Buy' ? _amountController.text : '0',
        'images': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
        'user_email': userEmail, // Store current user's email
      };

      // Save donation data to Firestore
      await _firestore.collection('donations').add(donationData);

      // Show Thank You Dialog
      _showThankYouDialog(context);
    } catch (e) {
      print('Error saving donation: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Function to upload images to Firebase Storage
  Future<String> _uploadImage(XFile imageFile, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Function to pick multiple images
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(selectedImages.take(5 - _imageFiles.length));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Replace with your primary color
          centerTitle: true,
          title: const Text(
            'Donate Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField('Pick-Up Location', _pickupAddressController),
                const SizedBox(height: 20),
                _buildTextField('Food Name', _itemDetailsController),
                const SizedBox(height: 20),
                _buildTextField('Number of Persons', _numPersonsController, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _buildTypeSelection(),
                const SizedBox(height: 20),
                if (_selectedType == 'Buy') _buildTextField('Amount (LKR)', _amountController, keyboardType: TextInputType.number),
                _buildPickupDateSelection(),
                const SizedBox(height: 20),
                _buildPickupTimeSelection(),
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 20),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Generic function to build text fields
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // Function to handle selection of Free/Buy types
  Widget _buildTypeSelection() {
    return Row(
      children: ['Free', 'Buy'].map((type) {
        bool isSelected = _selectedType == type;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedType = type;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? primaryColor: Colors.grey[200],
              foregroundColor: isSelected ? Colors.white : Colors.black,
            ),
            child: Text(type),
          ),
        );
      }).toList(),
    );
  }

  // Function to select pickup date
  Widget _buildPickupDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pickup Date', style: TextStyle(fontSize: 16)),
        Row(
          children: ['Today', 'Tomorrow', 'Day after'].map((String date) {
            return Row(
              children: <Widget>[
                Radio<String>(
                  value: date,
                  groupValue: _selectedPickupDate,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPickupDate = newValue!;
                    });
                  },
                ),
                Text(date),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // Function to select pickup time
  Widget _buildPickupTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pickup Time', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 10,
          children: <String>['7am - 9am', '10am - 12pm', '12pm - 2pm', '2pm - 4pm', '4pm - 6pm', '6pm - 8pm'].map((timeSlot) {
            return ChoiceChip(
              label: Text(timeSlot),
              selected: _selectedPickupTime == timeSlot,
              onSelected: (bool selected) {
                setState(() {
                  _selectedPickupTime = timeSlot;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Function to display the image picker
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Add Food Photos', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._imageFiles.map((XFile image) {
              return Image.file(
                File(image.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            }),
            if (_imageFiles.length < 5)
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.add_a_photo, color: primaryColor),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Submit button widget with loading indicator
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: SizedBox(
          width: 250,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _saveDonation();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Confirm Post',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  // Function to show a thank you dialog after successful submission
  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your donation has been successfully posted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
