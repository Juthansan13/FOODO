import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: 'John Doe', // Initial value fetched from profile
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'john.doe@example.com', // Initial value fetched from profile
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: '123 Main St, City, Country', // Initial value fetched from profile
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Nearby Place', // Initial value fetched from profile
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for save changes functionality
                Navigator.of(context).pop(); // Navigate back to ProfilePage after saving
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
