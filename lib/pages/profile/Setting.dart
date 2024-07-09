import 'package:firebase/color.dart';
import 'package:firebase/pages/Profile.dart';
import 'package:firebase/signIn.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
         automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 
               MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );

          },
        ),
        title: Text('Settings',
        style: TextStyle(color: Colors.white,),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDarkModeOption(),
            Divider(height: 32),
            _buildLanguageOption(),
            Divider(height: 32),
            _buildNotificationOption(),
            Divider(height: 32),
            _buildChangeDetailsSection(),
            Divider(height: 32),
            _buildChangePasswordSection(),
            Divider(height: 32),
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
        Text('Dark Mode', style: TextStyle(fontSize: 18)),
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
        Text('Language', style: TextStyle(fontSize: 18)),
        ListTile(
          title: Text('English'),
          leading: Radio( 
            value: 'english',
            groupValue: 'language',
            onChanged: (String? value) {
              // Handle language change
            },
          ),
        ),
        ListTile(
          title: Text('Tamil'),
          leading: Radio(
            value: 'tamil',
            groupValue: 'language',
            onChanged: (String? value) {
              // Handle language change
            },
          ),
        ),
        ListTile(
          title: Text('Sinhala'),
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
        Text('Notifications', style: TextStyle(fontSize: 18)),
        SwitchListTile(
          title: Text('Donation Notifications'),
          value: true,
          onChanged: (bool value) {
            // Handle notification switch
          },
        ),
        SwitchListTile(
          title: Text('Chat Messages'),
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
        Text('Change Details', style: TextStyle(fontSize: 18)),
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Location'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Phone No'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle update details
          },
          child: Text('Update Details'),
        ),
      ],
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Change Password', style: TextStyle(fontSize: 18)),
        TextField(
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle change password
          },
          child: Text('Change Password'),
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
        MaterialPageRoute(builder: (context) => SigninScreen(),
        ),
         );
      },
      child: Text('Log Out'),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Handle delete account

      },
      child: Text(
        'Delete Account',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

