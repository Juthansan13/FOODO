

import 'package:firebase/Account/AccountScreen.dart';
import 'package:firebase/pages/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase/pages/Post.dart';
import 'package:firebase/pages/DoHistory.dart';
import 'package:firebase/pages/Dashboard.dart';
import 'package:firebase/pages/Search.dart';
import 'package:firebase/color.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  

  @override
  State<Home> createState() => _HomeState();
  
}

class _HomeState extends State<Home> {

  int currentTab = 0;
  final List<Widget> screens = [
    const DashboardPage(),
    const DonationHistoryPage(),
     AccountScreen(),
    const Search(),
    const PostPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const DashboardPage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentScreen is! DashboardPage) {
          setState(() {
            currentScreen = const DashboardPage();
            currentTab = 0;
          });
          return false;
        } else {
          return true;
        }
      },
      //
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        //
        floatingActionButton: currentScreen is! PostPage
            ? FloatingActionButton(
                shape: const CircleBorder(),
                focusColor: Colors.white,
                backgroundColor: primaryColor,
                onPressed: () {
                  setState(() {
                    currentScreen = const PostPage();
                    currentTab = 4;
                  });
                },
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: currentScreen is! PostPage
            ? BottomAppBar(
                shape: const CircularNotchedRectangle(),
                height: 66,
                color: Colors.white,
              
                notchMargin: 8,
                child: Container(
                  
                
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MaterialButton(
                            minWidth: 40,
                            onPressed: (){
                               setState(() {
                                currentScreen = const DashboardPage();
                                currentTab = 0;
                            });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  color: currentTab == 0 ? primaryColor : Colors.grey,
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle( fontSize: currentTab == 0 ? 10 : 10, color: currentTab == 0? primaryColor:  Colors.grey),) 
                              ],
                            ),
                            
                          ),
                           MaterialButton(
                            minWidth: 10,
                            onPressed: (){
                               setState(() {
                                currentScreen = const Search();
                                currentTab = 1;
                            });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: currentTab == 1 ? primaryColor : Colors.grey,
                                ),
                                Text(
                                  'Search',
                                  style: TextStyle( fontSize: currentTab == 0 ? 10 : 10,color: currentTab == 1? primaryColor :  Colors.grey),) 
                              ],
                            ),
                            
                          ),
                        ]
                      ),
                     //SizedBox(width: 10),
                      //Row right
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MaterialButton(
                            minWidth: 40,
                            onPressed: (){
                               setState(() {
                                currentScreen = const ChatPage(email: '',);
                                currentTab = 2;
                            });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: currentTab == 2 ? primaryColor : Colors.grey,
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle( fontSize: currentTab == 0 ? 10 : 10,color: currentTab == 2? primaryColor :  Colors.grey),) 
                              ],
                            ),
                          
                            
                          ),
                           MaterialButton(
                            minWidth: 40,
                            onPressed: (){
                               setState(() {
                                currentScreen = AccountScreen();
                                currentTab = 3;
                            });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  color: currentTab == 3 ? primaryColor : Colors.grey,
                                ),
                                Text(
                                  'Account',
                                  style: TextStyle( fontSize: currentTab == 0 ? 10 : 10,color: currentTab == 3? primaryColor :  Colors.grey),) 
                              ],
                            ),
                            
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }

}
          
     