import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase/signIn.dart';
import 'package:firebase/color.dart'; 
import 'package:firebase/authmanagement/auth_service.dart'; // Correct import

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? errorMessage;

  // Add instance of AuthService
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          // Update display name (optional)
          await user.updateDisplayName(_emailController.text.trim());

          // Call createUserDocument after sign-up
          await _authService.createUserDocument(
            user.uid,
            _emailController.text.trim(),
            user.email!,
          );

          // Navigate to home screen
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     const SizedBox(height: 10),
                  Image.asset(
                    'assets/FOODOicon.png', // Your app logo
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                      const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                   
                          SizedBox(
                             width: 250,
                      child:TextFormField(
                          controller: _emailController,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "Please enter your email address";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email)) {
                              return "It's not a valid email address";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: Icon(Icons.email, color: primaryColor),
                            labelText: "Email Address",
                            labelStyle:
                                TextStyle(color: primaryColor, fontSize: 14),
                          ),
                        ),
                      ),
                          
                      SizedBox(
                             width: 250,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureTextPassword,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return "Please enter your password";
                            } else if (password.length < 8 ||
                                password.length > 15) {
                              return "Password length must be between 8 and 15 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextPassword = !_obscureTextPassword;
                                });
                              },
                            ),
                            labelText: "Password",
                            labelStyle:
                                const TextStyle(color: primaryColor, fontSize: 14),
                          ),
                        ),
                      ),
                     SizedBox(
                             width: 250,
                      
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureTextConfirmPassword,
                          validator: (confirmPassword) {
                            if (confirmPassword == null ||
                                confirmPassword.isEmpty) {
                              return "Please confirm your password";
                            } else if (confirmPassword !=
                                _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextConfirmPassword =
                                      !_obscureTextConfirmPassword;
                                });
                              },
                            ),
                            labelText: "Confirm Password",
                            labelStyle:
                                const TextStyle(color: primaryColor, fontSize: 14),
                          ),
                        ),
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: SizedBox(
                            height: 45,
                            width: 175,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: _signUp,
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                           ),
                      ),
                          //const SizedBox(height: 10),
                          const Text("Or sign up with"),
                          const SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _googleSignInButton(),
                                const SizedBox(width: 20),
                                
                              ],
                            ),
                          ),
                  
                       
                      //sigin option google and facebook 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?",
                          style: TextStyle(
                                 fontSize: 12),
                                  ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SigninScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  color: primaryColor, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
      /*
      await _firestore.collection('Users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profileImage': user.photoURL,
      });*
      */
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
  'name': user.displayName ?? 'No Name',
  'email': user.email ?? 'No Email',
  'profileImage': user.photoURL ?? '',
});


      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      
      Navigator.pop(context);
    } catch (error) {
      print("Error during Google sign-in: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
