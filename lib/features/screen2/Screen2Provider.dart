import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/features/screen2/model/Question.dart';

class Screen2Provider extends ChangeNotifier {
  Stream<List<QuestionList>> getPartIToeicList() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        firestore.collection('part_1_toeic').snapshots();

    return snapshots.map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<QuestionList> response = [];
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data()!;
        List<dynamic> questionList = data['question'] ?? [];
        List<Question> question = questionList.map((item) {
          return Question(
            A: item['A'],
            B: item['B'],
            C: item['C'],
            D: item['D'],
            image: item['image'],
            sound: item['sound'],
            true_answer: item['true_answer'],
          );
        }).toList();

        response.add(QuestionList(list_question: question));
      });

      return response;
    });
  }
}
