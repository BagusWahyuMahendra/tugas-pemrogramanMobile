import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/bg.png',
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "MyRecipe",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your culinary journey starts here",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/Logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        color: Color(0xFF009944),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        color: Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
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
    );
  }
}
