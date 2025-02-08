import 'package:firebase/Account/AccountInformation.dart';
import 'package:firebase/Account/Setting.dart';
import 'package:firebase/Onbording/onbording1.dart';
import 'package:firebase/color.dart';
import 'package:firebase/pages/DoHistory.dart';
import 'package:firebase/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _email;
  String? _profileImageUrl;
  String name = "";

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) async {
      setState(() {
        _user = event;
      });

      if (_user != null) {
       
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(_user!.uid).get();

        if (userDoc.exists) {
          setState(() {
            _email = userDoc['email'];
            _profileImageUrl = userDoc['profileImage'];
          });
        } else {
          
          await _firestore.collection('Users').doc(_user!.uid).set({
            'name': _user!.displayName ?? 'No name',
            'email': _user!.email,
            'profileImage': _user!.photoURL ?? '',
          });

          setState(() {
            _email = _user!.email;
            _profileImageUrl = _user!.photoURL ?? '';
          });

          print('User document created in Firestore');
        }
      }
    });
    _getCurrentUser(); 
  }


  void _getCurrentUser() {
    _user = _auth.currentUser; 
    if (_user != null) {
      _email = _user!.email!;
      _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_user != null) {
      try {
        
        DocumentSnapshot userDetailsDoc = await _firestore
            .collection('Account Information')
            .doc(_user!.uid) 
            .get();

        if (userDetailsDoc.exists) {
          Map<String, dynamic>? userData = userDetailsDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              name = userData['name'] ?? '';
             
            });
          }
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _refreshPage() async {
    
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
       // backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  /*
                  const Text(
                    'My account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8), */
                  _user != null ? _userInfo() : _account(),
                ],
              ),
            ),

            

            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account Information'),
              onTap: () {
                if(_user != null){
                  Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>const AccountInformationPage()
                  )
                );
                }else{
                  Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>const SigninScreen()
                  )
                );
                }
                //_user != null ? _userInfo() : _account();
                /*
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>AccountInformationPage()
                  )
                ); */
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Donation History'),
              onTap: () {
                
              
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonationHistoryPage()),
              );
              }
                 
                
              
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressListPage()));
                if(_user != null){
                  Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>const SettingsPage()
                  )
                );
                }else{
                  Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>const SigninScreen()
                  )
                );
                }
              },
            ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share the app'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About us'),
              onTap: () {},
            ),
        /*
            Center(
              child: MaterialButton(
                child: const Text("Sign Out"),
                onPressed: () async {
                  await _auth.signOut();
                  setState(() {
                    _user = null;
                  });
                },
              ),
            ),
        */
            
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }

  Widget _account() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Log in or sign up to view your complete profile',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Onboarding()),
              );
              
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.black,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _profileImageUrl != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_profileImageUrl!),
                )
              : const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50), 
                ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8), 
          Text(
            _email ?? "Email not available",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            //color: Colors.black,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 45),
             //Colors.black,
             foregroundColor: Colors.blue,
             backgroundColor: primaryColor
             
            ),
            child: const Text(
              "Sign Out",
               style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0) 
               ),
            ),
            onPressed: () async {
              await _auth.signOut();
              setState(() {
                _user = null;
              });
            },
            
          ),
          
          
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath, 
              height: 35,
              width: 35,
            ),
            
            Text(
              text,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), 
                fontSize: 13,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}