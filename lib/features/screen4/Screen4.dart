import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learning_app/utils.dart';
import 'package:translator_plus/translator_plus.dart';

class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String translated = "Translation";
  TextEditingController _input = TextEditingController();

  Future<String> translate(String input) async {
    final translator = GoogleTranslator();

    Translation translation = await translator.translate(input, to: 'vi');

    if (translation != null && translation.text != null) {
      return translation.text!;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.translate),
          title: Text("Translate"),
        ),
        floatingActionButton: IconButton(
          onPressed: () {},
          icon: Icon(Icons.translate),
        ),
        body: Column(
          children: [
            Expanded(
              child: Card(
                margin: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text("English"),
                    SizedBox(height: 8),
                    TextField(
                      controller: _input,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter your text",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
                      ),
                      maxLines: 10,
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text("VietNamese"),
                    SizedBox(height: 8),
                    FutureBuilder(
                      future: translate(_input.text.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(fontSize: 30),
                          );
                        } else {
                          return Text(
                            "Bản dịch",
                            style: TextStyle(fontSize: 30, color: Colors.grey),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
