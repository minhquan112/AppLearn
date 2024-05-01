import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/common/constant.dart';
import 'package:learning_app/features/home/model/Content.dart';
import 'package:learning_app/features/home/model/Process.dart';
import 'package:learning_app/features/home/model/Vocabulary.dart';

class HomeProvider extends ChangeNotifier {
  int dataSaveCount = 0;

  Stream<List<Content>> getDataHome() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        firestore.collection('data').snapshots();

    return snapshots.map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<Content> contents = [];

      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data()!;

        String title = data['title'];
        String image = data['image'];

        List<dynamic> vocaList = data['vocabulary'] ?? [];
        List<Vocabulary> vocabularies = vocaList.map((item) {
          return Vocabulary(
            name: item['name'],
            sound: item['sound'],
            spell: item['spell'],
          );
        }).toList();

        Content content = Content(
          title: title,
          image: image,
          listVoca: vocabularies,
        );

        contents.add(content);
      });

      return contents;
    });
  }

  Stream<String> getUserName() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection("users")
        .doc(Constants.userId)
        .snapshots()
        .map((snapshot) {
      dynamic process = snapshot.data()?['name'] ?? "";
      String _process = process.toString();
      return _process;
    });
  }

  Stream<Map<String, ProcessItem>> getProcess() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection("users")
        .doc(Constants.userId)
        .snapshots()
        .map((snapshot) {
      List<dynamic> process = snapshot.data()?['process'] ?? [];
      List<ProcessItem> _process = process.map((item) {
        return ProcessItem(
          title: item["title"],
          percent: item["percent"],
        );
      }).toList();
      Map<String, ProcessItem> response = {};
      for (ProcessItem i in _process) {
        response[i.title] = i;
      }

      return response;
    });
  }

  Stream<Map<String, String>> getProfile() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('users')
        .doc(Constants.userId)
        .snapshots()
        .map((snapshot) {
      String address = snapshot.data()?['address'] ?? "";
      String name = snapshot.data()?['name'] ?? "";
      String email = snapshot.data()?['email'] ?? "";

      Map<String, String> mp = {};
      mp['address'] = address;
      mp['name'] = name;
      mp['email'] = email;

      return mp;
    });
  }
}
