import 'package:firebase/color.dart';
import 'package:firebase/pages/profile/EditProfilePage.dart';
import 'package:firebase/pages/profile/Setting.dart';
import 'package:firebase/signIn.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Profile Information'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Donation History'),
              onTap: () {
                // Navigate to donation history page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
             Divider(),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Terms and conditions'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ,
                //   ),
                // );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninScreen(),
                  ),
                );
                // Placeholder for logout functionality
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
