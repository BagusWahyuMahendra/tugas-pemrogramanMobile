import 'package:flutter/material.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/signup.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Create an account",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        // TextField for Usernmae
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                        SizedBox(height: 10),
                        // TextField for Email
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                        SizedBox(height: 10),
                        // TextField for Phone Number
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                        SizedBox(height: 10),
                        // TextField for Password
                        TextField(
                          controller: passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      color: Color(0xff009944),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          " Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Or continue with",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle Google login
                        },
                        icon: Icon(FontAwesomeIcons.google),
                        iconSize: 25,
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle Facebook login
                        },
                        icon: Icon(FontAwesomeIcons.facebook),
                        iconSize: 25,
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle Instagram login
                        },
                        icon: Icon(FontAwesomeIcons.instagram),
                        iconSize: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
