import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/features/screen3/model/Quiz.dart';

class Screen3Provider extends ChangeNotifier {
  Stream<List<ListQuiz>> getListQuiz() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        firestore.collection('screen_3').snapshots();

    return snapshots.map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<ListQuiz> response = [];
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data()!;
        String title = data["title"].toString();
        List<dynamic> quizList = data['list_quiz'] ?? [];
        List<Quiz> quiz = quizList.map((item) {
          return Quiz(
            image: item['image'],
            true_answer: item['true_answer'],
          );
        }).toList();

        response.add(ListQuiz(title: title, list_quiz: quiz));
      });

      return response;
    });
  }
}
