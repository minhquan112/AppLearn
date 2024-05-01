import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/core/model/User.dart';
import 'package:learning_app/features/authentication/SignUpScreen.dart';
import 'package:learning_app/main_screen.dart';
import '../../common/color_resource.dart';
import '../../common/constant.dart';

TextEditingController _tk_loginController = TextEditingController();
TextEditingController _mk_loginController = TextEditingController();

void signIn(BuildContext context, String tk, String mk) async {
  try {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: tk,
      password: mk,
    );
    Constants.userId = userCredential.user!.uid;
    Constants.stateLogin = 1;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  } catch (e) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // _tk_loginController.text = "tes@gmail.com";
    // _mk_loginController.text = "123456";
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.fitHeight,
          colorFilter:
              ColorFilter.mode(Colors.red.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: ColorResources.mainBackGround()),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                  child: Container(
                    color: ColorResources.mainBackGround(),
                    height: Constants.screenHeight * 2 / 3,
                    width: Constants.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, right: 32),
                      child: ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32),
                              ),
                              Text(
                                "Please log in your information",
                                style: TextStyle(color: Colors.brown),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: _tk_loginController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Email:",
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                obscureText: true,
                                controller: _mk_loginController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Mật khẩu: ",
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  signIn(context, _tk_loginController.text,
                                      _mk_loginController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: Colors.brown,
                                  elevation: 20,
                                  shadowColor: Colors.brown,
                                  minimumSize: Size.fromHeight(60),
                                ),
                                child: Text(
                                  "Đăng nhập",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Not a member?"),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpScreen()));
                                      },
                                      child: Text("Register?")),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
