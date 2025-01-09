
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({super.key});

  @override
  _AccountInformationPageState createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  String name = "";
  String email = '';
  String mobile = '';
  String? gender;
  DateTime? selectedBirthday;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  User? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); 
  }

  void _getCurrentUser() {
    _user = _auth.currentUser; 
    if (_user != null) {
      email = _user!.email!;
      _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_user != null) {
      try {
        // Use uid as the document ID to fetch the user details
        DocumentSnapshot userDetailsDoc = await _firestore
            .collection('Account Information')
            .doc(_user!.uid) // Use uid as document ID
            .get();

        if (userDetailsDoc.exists) {
          Map<String, dynamic>? userData = userDetailsDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              name = userData['name'] ?? '';
              email = userData['email'] ?? _user!.email!;
              gender = userData['gender'] ?? '';
              selectedBirthday = (userData['birthday'] as Timestamp?)?.toDate();
              mobile = userData['mobile'] ?? '';
            });
          }
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _uploadUserData(Map<String, dynamic> data) async {
    if (_user != null) {
      try {
        // Use uid as the document ID to save the user details
        await _firestore.collection('Account Information').doc(_user!.uid).set(data, SetOptions(merge: true));
        print('User data uploaded successfully');
      } catch (e) {
        print('Error uploading user data: $e');
      }
    }
  }

  Future<void> _uploadName() async {
    if (name.isNotEmpty) {
      _uploadUserData({
        'name': name,
        'email': email, // Save email as a field
      });
      Navigator.pop(context);
    }
  }

  Future<void> _uploadGender() async {
    if (gender != null && gender!.isNotEmpty) {
      _uploadUserData({'gender': gender});
    } else {
      print('Gender is not set');
    }
  }

  Future<void> _uploadBirthday() async {
    if (selectedBirthday != null) {
      _uploadUserData({'birthday': Timestamp.fromDate(selectedBirthday!)});
    } else {
      print('Birthday not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Account Information'), 
      ),
      body: Column(
        children: [ 
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              height: 140,
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(5.0),
                children: [
                  ListTile(
                    title: const Text('Full Name'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ],
                    ),
                    onTap: () => _openFullNameModal(context),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Change Password'),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ],
                    ),
                    onTap: () => _openFullNameModal(context),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 295,
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(5.0),
              children: [
                ListTile(
                  title: const Text('Add Mobile'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mobile,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                  onTap: () {
                    // Implement mobile number update here
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Change Email'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                  onTap: () {
                    // Implement email update here
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Gender'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                      gender ?? 'Not set',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                  onTap: () => _openGenderSelectorModal(context),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Birthday'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedBirthday != null 
                            ? "${selectedBirthday!.year}-${selectedBirthday!.month.toString().padLeft(2, '0')}-${selectedBirthday!.day.toString().padLeft(2, '0')}" 
                            : '', 
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                  onTap: () => _openBirthdaySelector(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openFullNameModal(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Full Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        name = nameController.text;
                      });
                      _uploadName();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGenderSelectorModal(BuildContext context) {
    String? tempSelectedGender = gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Gender',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RadioListTile<String>(
                          title: const Text('Male'),
                          value: 'Male',
                          groupValue: tempSelectedGender,
                          onChanged: (value) {
                            setModalState(() {
                              tempSelectedGender = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Female'),
                          value: 'Female',
                          groupValue: tempSelectedGender,
                          onChanged: (value) {
                            setModalState(() {
                              tempSelectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              gender = tempSelectedGender;
                            });
                            _uploadGender();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openBirthdaySelector(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthday ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
    );

    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
      });
      _uploadBirthday();
    }
  }
}