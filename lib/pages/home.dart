import 'package:flutter/material.dart';
import 'package:firebase/pages/Post.dart';
import 'package:firebase/pages/DoHistory.dart';
import 'package:firebase/pages/Dashboard.dart';
import 'package:firebase/pages/Profile.dart';
import 'package:firebase/pages/Search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    DashboardPage(),
    DoHistory(),
    ProfilePage(),
    Search(),
    PostPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DashboardPage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentScreen is! DashboardPage) {
          setState(() {
            currentScreen = DashboardPage();
            currentTab = 0;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: currentScreen is! PostPage
            ? FloatingActionButton(
                child: Icon(Icons.add),
                shape: CircleBorder(),
                backgroundColor: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    currentScreen = PostPage();
                  });
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: currentScreen is! PostPage
            ? BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 8,
                child: Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            minWidth: 70,
                            onPressed: () {
                              setState(() {
                                currentScreen = DashboardPage();
                                currentTab = 0;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 30,
                                  color: currentTab == 0
                                      ? Colors.lightGreen
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            minWidth: 70,
                            onPressed: () {
                              setState(() {
                                currentScreen = Search();
                                currentTab = 1;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 30,
                                  color: currentTab == 1
                                      ? Colors.lightGreen
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            minWidth: 70,
                            onPressed: () {
                              setState(() {
                                currentScreen = DoHistory();
                                currentTab = 2;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 30,
                                  color: currentTab == 2
                                      ? Colors.lightGreen
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            minWidth: 70,
                            onPressed: () {
                              setState(() {
                                currentScreen = ProfilePage();
                                currentTab = 3;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: currentTab == 3
                                      ? Colors.lightGreen
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
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
