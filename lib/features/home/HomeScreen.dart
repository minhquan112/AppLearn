import 'package:flutter/material.dart';
import 'package:learning_app/common/constant.dart';
import 'package:learning_app/features/authentication/LoginScreen.dart';
import 'package:learning_app/features/home/HomeProvider.dart';
import 'package:learning_app/features/home/LearnVocabularySceen.dart';
import 'package:learning_app/features/home/model/Content.dart';
import 'package:learning_app/features/home/model/Process.dart';
import 'package:learning_app/main_screen.dart';
import 'package:learning_app/utils.dart';
import 'package:provider/provider.dart';

TextEditingController searchController = TextEditingController();

List<Color> colors = [
  Colors.cyan,
  Colors.yellow,
  Colors.deepOrangeAccent,
  Colors.blueAccent,
  Colors.lightGreen,
  Colors.purple
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late HomeProvider viewmodel;

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Constants.stateLogin == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              : StreamBuilder(
                  stream: viewmodel.getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String name = snapshot.data ?? "You";
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            Text("Hello $name", style: TextStyle(fontSize: 15)),
                            SizedBox(width: 5),
                            IconButton(
                                onPressed: () {
                                  Constants.stateLogin = 0;
                                  viewmodel.dataSaveCount = 0;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()),
                                    (route) => false,
                                  );
                                },
                                icon: Icon(Icons.login_rounded)),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 50,
                        width: 50,
                        child: Utils.Loading(),
                      );
                    }
                  }),
        ],
      ),
      body: Constants.stateLogin == 0
          ? StreamBuilder(
              stream: viewmodel.getDataHome(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Content> contents = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        Content item = contents[index];
                        return Item(item, "", index);
                      },
                    ),
                  );
                } else {
                  return Container(
                    height: 30,
                    width: 30,
                    child: Utils.Loading(),
                  );
                }
              },
            )
          : StreamBuilder(
              stream: viewmodel.getProcess(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, ProcessItem> mp = snapshot.data ?? {};
                  return StreamBuilder(
                    stream: viewmodel.getDataHome(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Content> contents = snapshot.data!;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: ListView.builder(
                            itemCount: contents.length,
                            itemBuilder: (context, index) {
                              Content item = contents[index];
                              ProcessItem process =
                                  mp[item.title] ?? ProcessItem();
                              return Item(item, process.percent, index);
                            },
                          ),
                        );
                      } else {
                        return Container(
                          height: 30,
                          width: 30,
                          child: Utils.Loading(),
                        );
                      }
                    },
                  );
                } else {
                  return Container(
                    height: 30,
                    width: 30,
                    child: Utils.Loading(),
                  );
                }
              },
            ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: Constants.screenHeight / 4,
              width: Constants.screenHeight / 4,
              child: Image.asset("assets/iconapp2.png"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.bookmark_added,
                color: Colors.black,
              ),
              title: Text(
                "Điều khoản",
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_sharp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.description_rounded,
                color: Colors.black,
              ),
              title: Text(
                "Giới thiệu",
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_sharp,
                color: Colors.black,
              ),
            ),
            Constants.stateLogin == 0
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : StreamBuilder(
                    stream: viewmodel.getProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, String> data = snapshot.data ?? {};
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                "Họ tên: ${data['name']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 2),
                            ListTile(
                              title: Text(
                                "Email: ${data['email']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 2),
                            ListTile(
                              title: Text(
                                "Địa chỉ: ${data['address']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 2),
                            Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Constants.stateLogin = 0;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Đăng xuất",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            )
                          ],
                        );
                      } else {
                        return Container(
                          height: 50,
                          width: 50,
                          child: Utils.Loading(),
                        );
                      }
                    })
          ],
        ),
      ),
    );
  }

  Widget Item(Content item, String process, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearnVocabularyScreen(
                  vocabularies: item.vocabulary, content: item),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(right: 5, left: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: colors[index % 6],
            borderRadius: BorderRadius.circular(12),
          ),
          height: Constants.screenHeight / 8,
          width: Constants.screenWidth - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      item.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.pinkAccent,
                    child: Constants.stateLogin == 1
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Đã học được: $process",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Text(""),
                  ),
                ],
              ),
              Image.network(
                item.image,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
