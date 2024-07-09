import 'package:firebase/color.dart';
import 'package:flutter/material.dart';

class DoHistory extends StatefulWidget {
  const DoHistory({super.key});

  @override
  State<DoHistory> createState() => _DoHistoryState();
}

class _DoHistoryState extends State<DoHistory> {
  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Set the background color here
          automaticallyImplyLeading: false,
          centerTitle: true, // Center the title
          title: const Text(
            'Donation History',
            style: TextStyle(
              color: Colors.white, // Set the text color here if needed
            ),
          ),
        ),
      body:Center(child: Text('Donation HISTORY ',style: TextStyle(fontSize: 40))),
    ),
     );
     
  }
}