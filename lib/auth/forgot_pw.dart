import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPw extends StatefulWidget {
  const ForgotPw({super.key});

  @override
  State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {
  // text controller
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Loading
  bool _isReset = false;

  // Reset password
  Future<void> resetPassowrd() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Fluttertoast.showToast(
        msg: "Password Reset link was sent! Check your email.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseAuthException catch (e) {
      // Show message when invalid email
      Fluttertoast.showToast(
        msg: 'Please enter E-mail you want to reset...!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      debugPrint(e.toString());
    }

    // clear E-mail when clicked
    _emailController.clear();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.purple[800],
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      height: 180.0,
                      width: 180.0,
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
                  ),
                  const SizedBox(height: 40.0),
                  _buildText('FORGOT PASSWORD?', 30.0),
                  _buildText('Enter your E-mail below:', 20.0),
                  const SizedBox(height: 15),

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
                  // Reset button
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Loading
                      setState(() => _isReset = true);
                      await resetPassowrd().whenComplete(
                        () => setState(() => _isReset = false),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isReset
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
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Reset',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
