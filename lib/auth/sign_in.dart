import 'package:blog_app/auth/forgot_pw.dart';
import 'package:blog_app/auth/google.dart';
import 'package:blog_app/auth/sign_up.dart';
import 'package:blog_app/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Show & hide password
  bool _obscureText = true;

  // Loading
  bool isLogin = false;
  bool isGoogle = false;

  // User login account
  Future<void> userLogin() async {
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
        print('Please enter your E-mail and password...!');
      } else {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Check user is not null
        if (credential != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
            (route) => false,
          );
          print('Signed In...!');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "No user found that account...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "Invalid password...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
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
              _buildText('SIGN IN', 50.0),
              _buildText('to use your your account', 15.0),
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
                  hintStyle: GoogleFonts.kantumruyPro(fontSize: 15.0),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),

              // Password
              const SizedBox(height: 10),
              // Password
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple.withOpacity(.1),
                  hintText: 'Password',
                  hintStyle: GoogleFonts.kantumruyPro(fontSize: 17.0),

                  // Toggle icon to show and hide password
                  prefixIcon: const Icon(Icons.password, size: 25),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),

              // Fotgot password button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPw(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  )
                ],
              ),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // Loading
                  setState(() => isLogin = true);
                  await userLogin().whenComplete(
                    () => setState(() => isLogin = false),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLogin
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
                        'Login',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              // or Continue with
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),

              // Sign In with Facebook & Google
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  // loading
                  setState(() => isGoogle = true);
                  await signInWithGoogle(context).whenComplete(
                    () => setState(() => isGoogle = false),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isGoogle
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
                        'Google',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have account yet?',
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
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: Text(
                      'SIGN UP',
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
