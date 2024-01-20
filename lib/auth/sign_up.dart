import 'package:blog_app/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conPasswordController = TextEditingController();

  // Show & hide passsword
  bool obscureText = true;
  // Loading
  bool isSignup = false;

  // confirm password
  bool passwordConfirmed() {
    if (_passwordController.text == _conPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  // User sign up account
  Future<void> userSignup() async {
    try {
      if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter E-mail and password...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Please enter E-mail and password...!');
      } else {
        if (passwordConfirmed()) {
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              )
              .whenComplete(() => Navigator.pop(context));
          if (credential != null) {
            Fluttertoast.showToast(
              msg: "Signed up...!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            print('Signed up...!');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "Weak password...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        Fluttertoast.showToast(
          msg: "Already exists for that email...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Image
              const SizedBox(height: 20.0),
              Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple,
                    width: 5,
                  ),
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(
                      'images/Blog.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildText('SIGN UP', 50.0),
              _buildText('to create your your account', 15.0),
              const SizedBox(height: 15.0),
              const Divider(thickness: 2.0),
              const SizedBox(height: 15.0),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple.withOpacity(.1),
                  hintText: 'E-mail',
                  hintStyle: GoogleFonts.kantumruyPro(fontSize: 17.0),
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Password
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple.withOpacity(.1),
                  hintText: 'Password',
                  hintStyle: GoogleFonts.kantumruyPro(fontSize: 17.0),
                  prefixIcon: const Icon(Icons.password, size: 25),
                ),
              ),
              const SizedBox(height: 10),
              // Confirm Password
              TextFormField(
                controller: _conPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple.withOpacity(.1),
                  hintText: 'Confirm Password',
                  hintStyle: GoogleFonts.kantumruyPro(fontSize: 17.0),
                  prefixIcon: const Icon(Icons.password, size: 25),

                  // Toggle icon to show and hide password
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          obscureText = !obscureText;
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),
              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // loading
                  setState(() => isSignup = true);
                  await userSignup().whenComplete(
                    () => setState(() => isSignup = false),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSignup
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.white,
                            size: 40.0,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Loading',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Sign Up',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have account?',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                    child: Text(
                      'SIGN IN',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text
  Widget _buildText(String text, double fontSize) {
    return Text(
      text,
      style: GoogleFonts.kantumruyPro(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
