import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase/signUp.dart';
import 'package:firebase/color.dart';
import 'package:firebase/authmanagement/auth_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool _obscureText = true;
  String? errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          await _authService.createUserDocument(
            user.uid,
            user.displayName ?? 'Anonymous',
            user.email!,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      } catch (error) {
        setState(() {
          errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/FOODOicon.png', height: 100, width: 100),
                  const SizedBox(height: 10),
                  const Text(
                    "SIGN IN",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildTextField(_emailController, Icons.email, "Email"),
                        const SizedBox(height: 0),
                        _buildTextField(
                            _passwordController, Icons.lock, "Password",
                            isPassword: true),
                        const SizedBox(height: 0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 14)),
                          ),
                        ),
                        const SizedBox(height: 0),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              elevation: 4, // Adds a subtle shadow effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Softer rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _signIn,
                            child: const Text(
                              "SIGN IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing:
                                    1.2, // Slight spacing for readability
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _googleSignInButton(),
                        const SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()),
                                );
                              },
                              child: const Text("Create Account",
                                  style: TextStyle(color: primaryColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String label,
      {bool isPassword = false}) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 8), // Add spacing between fields
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your $label";
          }
          return null;
        },
        style: const TextStyle(fontSize: 16, color: Colors.black), // Text style
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 20), // Padding inside input
          prefixIcon: Icon(icon, color: primaryColor),
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded border
            borderSide: BorderSide.none, // Remove default border
          ),
          filled: true,
          fillColor: Colors.white, // Background color
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: primaryColor),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        icon: Image.asset(
          "assets/google.png",
          height: 24,
          width: 24,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Softer rounded corners
          ),
          side: const BorderSide(
              color: Colors.black, width: 1.2), // Bolder border
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.white, // Keeps it clean
          elevation: 1, // Slight shadow for better visibility
        ),
        onPressed: _handleGoogleSignIn,
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);
      User user = userCredential.user!;

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'name': user.displayName ?? 'No Name',
        'email': user.email ?? 'No Email',
        'profileImage': user.photoURL ?? '',
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }
}
