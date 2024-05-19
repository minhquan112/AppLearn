import 'package:flutter/material.dart';
import 'package:learning_app/common/constant.dart';
import 'package:learning_app/features/screen3/Screen3Provider.dart';
import 'package:learning_app/features/screen3/TestQuiz.dart';
import 'package:learning_app/features/screen3/model/Quiz.dart';
import 'package:learning_app/utils.dart';
import 'package:provider/provider.dart';

List<Color> colors = [
  Colors.cyan,
  Colors.yellow,
  Colors.deepOrangeAccent,
  Colors.blueAccent,
  Colors.lightGreen,
  Colors.purple
];

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    Screen3Provider viewmodel = Provider.of<Screen3Provider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.quiz_rounded),
        title: Text("Quiz"),
      ),
      body: StreamBuilder(
        stream: viewmodel.getListQuiz(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ListQuiz> questionList = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: questionList.length,
                itemBuilder: (context, index) {
                  return Item(questionList[index], index);
                },
              ),
            );
          } else {
            return Utils.Loading();
          }
        },
      ),
    );
  }

  Widget Item(ListQuiz item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TestQuiz(title: item.title, quizList: item.list_quiz)));
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
                  Text(
                    "Chủ đề: ${item.title}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("Điền từ được mô tả trong tranh"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
