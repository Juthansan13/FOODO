import 'package:firebase/color.dart';
import 'package:firebase/pages/DoHistory.dart';
import 'package:firebase/pages/profile/EditProfilePage.dart';
import 'package:firebase/Account/Setting.dart';
import 'package:firebase/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add this import for caching images

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Fallback to 'John Doe' if the user is null or no display name is available
    String displayName = user?.displayName ?? '';
    String email = user?.email ?? 'No Email';
    String profileImageUrl = user?.photoURL ?? ''; // Use the user's photoURL if available, otherwise fallback to the default avatar.

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Set the background color here
          automaticallyImplyLeading: false,
          centerTitle: true, // Center the title
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white, // Set the text color here if needed
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                child: Column(
                  children: <Widget>[
                    // Check if the user's profile image URL exists, if not fallback to a default image
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl.startsWith('http')
                          ? CachedNetworkImageProvider(profileImageUrl) // Use cached image if the URL is valid
                          : const AssetImage('') as ImageProvider, // Default image
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,  // Display the user's name here
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,  // Display the user's email here
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile Information'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Donation History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonationHistoryPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Terms and conditions'),
                onTap: () {
                  // Handle terms and conditions navigation
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();  // Log out the user
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
