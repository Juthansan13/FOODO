import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase/pages/home.dart'; // Adjust import to your file structure
import 'package:firebase/color.dart'; // Adjust import to your file structure
import 'dart:io';

class PostPage extends StatefulWidget {
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
  TimeOfDay selectedTime = TimeOfDay.now();

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
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                _buildTextField('Pick-Up Location', _pickupAddressController),
               
                SizedBox(height: 20),
                _buildTextField('Item Details', _itemDetailsController),
                SizedBox(height: 20),
                _buildTextField('Number of Persons', _numPersonsController, keyboardType: TextInputType.number),
                SizedBox(height: 20),
                _buildPickupDateSelection(),
                SizedBox(height: 20),
                _buildPickupTimeSelection(),
                SizedBox(height: 20),
                _buildImagePicker(),
                SizedBox(height: 20),
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
        Text('Pickup Date', style: TextStyle(fontSize: 16)),
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
        Text('Pickup Time', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 10,
          children: <String>[
            '7am - 9am', '10am - 12pm', '12pm - 2pm', '2pm - 4pm', '4pm - 6pm'
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
        Text('Add Food Photos', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
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
            }).toList(),
            if (_imageFiles.length < 5)
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.add_a_photo, color: primaryColor),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(imageQuality: 50);
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles.take(5 - _imageFiles.length));
      });
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _showThankYouDialog(context);
          }
        },
        child: Text('Confirm Post'),
      ),
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank you!'),
          content: Text('Thank you for donating food.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
