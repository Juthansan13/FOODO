import 'package:firebase/Account/AccountScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase/signUp.dart';
import 'package:firebase/color.dart';
import 'package:firebase/authmanagement/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _obscureText = true;
  String? errorMessage;
  final AuthService _authService = AuthService();

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
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Center( // Center alignment for all elements
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/FOODOicon.png', // Your app logo
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                             width: 250,
                          child:TextFormField(
                            controller: _emailController,
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email)) {
                                return "Invalid email format";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email,
                                  color: primaryColor),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                  color: primaryColor,fontSize: 14),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryColor),
                              ),
                            ),
                          ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                             width: 250,
                          child:
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            validator: (password) {
                              if (password == null || password.isEmpty) {
                                return "Please enter your password";
                              } else if (password.length < 8 ||
                                  password.length > 15) {
                                return "Password must be 8-15 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,
                                  color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                  color: primaryColor,fontSize: 14),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryColor),
                              ),
                            ),
                          ),
                          ),
                          const SizedBox(height: 10),
                           Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Implement password reset functionality here
                              },
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 12),
                              ),
                            ),
                           ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 175,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              
                              onPressed: _signIn,
                              child: const Text(
                                "SIGN IN",
                                style: TextStyle(
                                   letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text("Or sign in with"),
                          const SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _googleSignInButton(),
                                //const SizedBox(width: 20),
                                
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?",
                               style: TextStyle(
                                      //color: primaryColor,
                                      fontSize: 12),
                                      ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen()),
                                  );
                                },
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        width: 250,
        child: ElevatedButton.icon(
          
          icon: Image.asset(
            "assets/google.png",
            height: 24,
            width: 24,
          ),
          label: const Text(
            "Continue with Google",
            style: TextStyle(
              color: Colors.black
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            iconColor:  Colors.white,
          shadowColor:  Colors.black,
            side: const BorderSide(color: Colors.black)
          ),
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }
  

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithProvider(googleAuthProvider);

      // Get user from the result
      User user = userCredential.user!;

      // Store user data in Firestore
     /* await _firestore.collection('Users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profileImage': user.photoURL,
      });*/
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
  'name': user.displayName ?? 'No Name',
  'email': user.email ?? 'No Email',
  'profileImage': user.photoURL ?? '',
});


      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      
      //Navigator.pop(context);
    } catch (error) {
      print("Error during Google sign-in: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }


}
