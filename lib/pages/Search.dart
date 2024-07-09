import 'package:firebase/color.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Set the background color here
          automaticallyImplyLeading: false,
          centerTitle: true, // Center the title
          title: AnimSearchBar(
            width: 400,
             textController: _textController,
             onSuffixTap: () {
               setState(() {
                 _textController.clear();
               });
            },
            rtl: true,
            onSubmitted: (String value) {
            // handle search query submission
            },
           ),
        ),
      // appBar: PreferredSize(

        
      //   preferredSize: const Size.fromHeight(80.0),
      //   child: AppBar(
      //      automaticallyImplyLeading: false, 
      //     title: AnimSearchBar(
      //       width: 400,
      //       textController: _textController,
      //       onSuffixTap: () {
      //         setState(() {
      //           _textController.clear();
      //         });
      //       },
      //       rtl: true,
      //       onSubmitted: (String value) {
      //         // handle search query submission
      //       },
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Center(
          child: Text('Content goes here'),
        ),
      ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
