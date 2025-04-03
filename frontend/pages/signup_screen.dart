import 'package:flutter/material.dart';
import 'package:todo_app/frontend/api_services/auth_api_service.dart';
import 'package:todo_app/frontend/api_services/todo_api_service.dart';
import 'package:todo_app/frontend/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Auth_APIService AuthAPIService = Auth_APIService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 60),
              Column(
                children: [
                  Icon(Icons.account_circle,
                      size: 80, color: Colors.yellow[100]),
                  const SizedBox(height: 16),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.yellow[200],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Boost Your Productivity – Join Now!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Username Field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                child: TextFormField(
                  controller: userName,
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded,
                        color: Colors.yellow[100]),
                    labelText: "Username",
                    floatingLabelStyle: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 24,
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 20),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
              ),
              // Email Field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email_outlined, color: Colors.yellow[100]),
                    labelText: "Email",
                    floatingLabelStyle: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 24,
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 20),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              // Password Field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                child: TextFormField(
                  controller: password,
                  obscureText: _obscurePassword,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock, color: Colors.yellow[100]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelText: "Password",
                    floatingLabelStyle: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 24,
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 20),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              // Confirm Password Field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                child: TextFormField(
                  controller: confirmPassword,
                  obscureText: _obscureConfirmPassword,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.yellow[100]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelText: "Confirm Password",
                    floatingLabelStyle: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 24,
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 20),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              // Sign Up Button
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
                child: ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Creating account for ${userName.text}'),
                          backgroundColor: Colors.black.withOpacity(0.9),
                        ),
                      );
                      Map<String,dynamic> userData = {};
                      userData['userName'] = userName.text;
                      userData['email'] = email.text;
                      userData['password'] = password.text;
                      userData['confirmPassword'] = confirmPassword.text;
                      bool isSignupSuccessful = await AuthAPIService.createAccount(userData);
                      if(isSignupSuccessful){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Error in creating your account!'),
                            backgroundColor: Colors.black.withOpacity(0.9),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    backgroundColor: Colors.yellow[50],
                  ),
                ),
              ),
              // Already have an account
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                      },
                      child: Text(
                        'Log In>',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.yellow[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
