import 'package:firebase/color.dart';
import 'package:firebase/signIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase/authmanagement/authmanage.dart'; // Ensure this import path is correct

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0), // Add padding to top and bottom
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust horizontal padding as needed
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center alignment
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                        child: Image.asset("assets/siginup.png"), // Ensure the image path is correct
                      ),
                      Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10), // Add space between the title and the form fields
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          onSaved: (value) {
                          },
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: Icon(Icons.person, color: primaryColor),
                            labelText: "User Name",
                            labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: emailController,
                          onSaved: (value) {
                          },
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
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:primaryColor),
                            ),
                            prefixIcon: Icon(Icons.email, color: primaryColor),
                            labelText: "Email Address",
                            labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: passwordController,
                          onSaved: (value) {
                          },
                          obscureText: _obscureTextPassword,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return "Please enter your password";
                            } else if (password.length < 8 || password.length > 15) {
                              return "Password length must be between 8 and 15 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: Icon(Icons.lock, color: primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextPassword = !_obscureTextPassword;
                                });
                              },
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          onSaved: (value) {
                          },
                          obscureText: _obscureTextConfirmPassword,
                          validator: (confirmPassword) {
                            if (confirmPassword == null || confirmPassword.isEmpty) {
                              return "Please confirm your password";
                            } else if (confirmPassword != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            prefixIcon: Icon(Icons.lock, color: primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                                });
                              },
                            ),
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: primaryColor, fontSize: 16),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: SizedBox(
                            height: 50.0,
                            width: 300,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    await AuthManage().signUp(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                      ),
                                    );
                                  } catch (error) {
                                    setState(() {
                                      errorMessage = error.toString();
                                    });
                                  }
                                }
                              },
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),                       
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: primaryColor, fontSize: 16),
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
}
