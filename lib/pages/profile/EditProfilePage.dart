import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: 'John Doe', // Initial value fetched from profile
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: 'john.doe@example.com', // Initial value fetched from profile
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: '123 Main St, City, Country', // Initial value fetched from profile
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: 'Nearby Place', // Initial value fetched from profile
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for save changes functionality
                Navigator.of(context).pop(); // Navigate back to ProfilePage after saving
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
