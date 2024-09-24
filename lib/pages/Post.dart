import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/color.dart';
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
  final List<XFile> _imageFiles = [];

  String _selectedPickupDate = 'Today';
  String _selectedPickupTime = '7am - 9am';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save donation details to Firestore
  Future<void> _saveDonation() async {
    try {
      List<String> imageUrls = [];
      // Upload each image and get the download URL
      for (XFile imageFile in _imageFiles) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String imageUrl = await _uploadImage(imageFile, fileName);
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
          print('Image URL uploaded: $imageUrl');  // Debugging step
        }
      }

      print('Final image URLs list: $imageUrls');  // Debugging step

      // Create donation data object
      final donationData = {
        'pickup_location': _pickupAddressController.text,
        'item_details': _itemDetailsController.text,
        'num_persons': int.parse(_numPersonsController.text),
        'pickup_date': _selectedPickupDate,
        'pickup_time': _selectedPickupTime,
        'images': imageUrls, // Ensure this contains valid URLs
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save donation data to Firestore
      await _firestore.collection('donations').add(donationData);
      _showThankYouDialog(context);
    } catch (e) {
      print('Error saving donation: $e');
    }
  }

  // Function to upload an image to Firebase Storage
  Future<String> _uploadImage(XFile imageFile, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Uploaded image download URL: $downloadUrl');  // Debugging step
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // UI Part
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            'Donate Details',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                _buildTextField('Pick-Up Location', _pickupAddressController),
                const SizedBox(height: 20),
                _buildTextField('Food Name', _itemDetailsController),
                const SizedBox(height: 20),
                _buildTextField('Number of Persons', _numPersonsController, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
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

  Widget _buildPickupDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pickup Date', style: TextStyle(fontSize: 16)),
        Row(
          children: <Widget>[
            _buildRadioOption('Today'),
            _buildRadioOption('Tomorrow'),
            _buildRadioOption('Day after'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: <Widget>[
        Radio<String>(
          value: value,
          groupValue: _selectedPickupDate,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPickupDate = newValue!;
            });
          },
        ),
        Text(value),
      ],
    );
  }

  Widget _buildPickupTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pickup Time', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 10,
          children: <String>[
            '7am - 9am', '10am - 12pm', '12pm - 2pm', '2pm - 4pm', '4pm - 6pm','6pm-8pm',
          ].map((String timeSlot) {
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

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(imageQuality: 50);
    setState(() {
      _imageFiles.addAll(pickedFiles.take(5 - _imageFiles.length));
    });
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await _saveDonation();
          }
        },
        child: const Text('Confirm Post'),
      ),
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!'),
          content: const Text('Thank you for donating food.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
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
