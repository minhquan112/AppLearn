import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/core/model/User.dart';
import 'package:learning_app/features/authentication/SignUpScreen.dart';
import 'package:learning_app/main_screen.dart';
import 'package:learning_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/color_resource.dart';
import '../../common/constant.dart';

Future<void> _saveLoginInfo(String email, String password, bool save) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (save) {
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('save', save);
  } else {
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('save');
  }
}

void signIn(BuildContext context, String tk, String mk) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Utils.Loading();
      },
    );
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
    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text("Đăng nhập thất bại!"),
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = true;
  TextEditingController _tkLoginController = TextEditingController();
  TextEditingController _mkLoginController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tkLoginController.text = prefs.getString('email') ?? '';
      _mkLoginController.text = prefs.getString('password') ?? '';
      _isChecked = prefs.getBool('save') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
            Colors.red.withOpacity(0.5),
            BlendMode.dstATop,
          ),
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
                    bottomLeft: Radius.circular(12),
                  ),
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
                                  fontSize: 32,
                                ),
                              ),
                              Text(
                                "Please log in your information",
                                style: TextStyle(color: Colors.brown),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: _tkLoginController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
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
                              SizedBox(height: 15),
                              TextField(
                                obscureText: true,
                                controller: _mkLoginController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
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
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.brown,
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                  Text("Lưu mật khẩu?"),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  _saveLoginInfo(_tkLoginController.text,
                                      _mkLoginController.text, _isChecked);
                                  signIn(
                                    context,
                                    _tkLoginController.text,
                                    _mkLoginController.text,
                                  );
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
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Not a member?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: Text("Register?"),
                                  ),
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
