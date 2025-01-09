import 'package:firebase/color.dart';
import 'package:firebase/pages/Profile.dart';
import 'package:firebase/signIn.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
         automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 
               MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );

          },
        ),
        title: const Text('Settings',
        style: TextStyle(color: Colors.white,),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDarkModeOption(),
            const Divider(height: 32),
            _buildLanguageOption(),
            const Divider(height: 32),
            _buildNotificationOption(),
            const Divider(height: 32),
            _buildChangeDetailsSection(),
            const Divider(height: 32),
            _buildChangePasswordSection(),
            const Divider(height: 32),
            _buildLogoutButton(context),
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildDarkModeOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Dark Mode', style: TextStyle(fontSize: 18)),
        Switch(
          value: false,
          onChanged: (bool value) {
            // Handle dark mode switch
          },
        ),
      ],
    );
  }

  Widget _buildLanguageOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Language', style: TextStyle(fontSize: 18)),
        ListTile(
          title: const Text('English'),
          leading: Radio( 
            value: 'english',
            groupValue: 'language',
            onChanged: (String? value) {
              // Handle language change
            },
          ),
        ),
        ListTile(
          title: const Text('Tamil'),
          leading: Radio(
            value: 'tamil',
            groupValue: 'language',
            onChanged: (String? value) {
              // Handle language change
            },
          ),
        ),
        ListTile(
          title: const Text('Sinhala'),
          leading: Radio(
            value: 'sinhala',
            groupValue: 'language',
            onChanged: (String? value) {
              // Handle language change
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Notifications', style: TextStyle(fontSize: 18)),
        SwitchListTile(
          title: const Text('Donation Notifications'),
          value: true,
          onChanged: (bool value) {
            // Handle notification switch
          },
        ),
        SwitchListTile(
          title: const Text('Chat Messages'),
          value: true,
          onChanged: (bool value) {
            // Handle notification switch
          },
        ),
      ],
    );
  }

  Widget _buildChangeDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Change Details', style: TextStyle(fontSize: 18)),
        const TextField(
          decoration: InputDecoration(labelText: 'Email'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Name'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Location'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Phone No'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle update details
          },
          child: const Text('Update Details'),
        ),
      ],
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Change Password', style: TextStyle(fontSize: 18)),
        const TextField(
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle change password
          },
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Background color
      ),
      onPressed: () {
        // Handle logout
         Navigator.pop(context, 
        MaterialPageRoute(builder: (context) => const SigninScreen(),
        ),
         );
      },
      child: const Text('Log Out'),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Handle delete account

      },
      child: const Text(
        'Delete Account',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

