import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:learning_app/common/color_resource.dart';
import 'package:learning_app/common/constant.dart';
import 'package:learning_app/features/home/HomeProvider.dart';
import 'package:learning_app/features/home/model/Content.dart';
import 'package:learning_app/features/home/model/Process.dart';
import 'package:learning_app/features/home/model/Vocabulary.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class LearnVocabularyScreen extends StatefulWidget {
  final List<Vocabulary> vocabularies;
  final Content content;

  LearnVocabularyScreen({
    required this.vocabularies,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  _LearnVocabularyScreenState createState() => _LearnVocabularyScreenState();
}

class _LearnVocabularyScreenState extends State<LearnVocabularyScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  late HomeProvider viewmodel;
  final audioRecord = Record();
  final audioPlayer = AudioPlayer();
  bool isRecording = false;
  String audioPath = "";

  void playSound(String soundUrl) async {
    await _audioPlayer.play(UrlSource(soundUrl));
  }

  Future<void> startRecord() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {}
  }

  Future<void> stopRecord() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {}
  }

  Future<void> playRecord() async {
    try {
      await audioPlayer.play(UrlSource(audioPath));
    } catch (e) {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Vocabulary> _vocabularies = widget.vocabularies;
    viewmodel = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chủ đề: ${widget.content.title}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: Constants.screenHeight / 3,
              child: Image.network(widget.content.image),
            ),
          ),
          CarouselSlider.builder(
            itemCount: _vocabularies.length,
            itemBuilder: (context, index, pageIndex) {
              Vocabulary item = _vocabularies[index];
              return Padding(
                padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                child: Container(
                  width: Constants.screenWidth - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorResources.vocabularyItem(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item.spell),
                      SizedBox(height: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                playSound(item.sound);
                              },
                              icon: Icon(Icons.volume_up_sharp),
                            ),
                            isRecording == true
                                ? IconButton(
                                    onPressed: () {
                                      stopRecord();
                                    },
                                    icon: Icon(Icons.mic_off_sharp),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      startRecord();
                                    },
                                    icon: Icon(Icons.mic_none_outlined),
                                  ),
                            IconButton(
                              onPressed: () {
                                playRecord();
                              },
                              icon: Icon(Icons.play_arrow_rounded),
                            ),
                            Constants.stateLogin == 0
                                ? Text("")
                                : IconButton(
                                    onPressed: () {
                                      if (viewmodel.dataSaveCount <
                                          widget.vocabularies.length)
                                        viewmodel.dataSaveCount++;
                                      updateProcessToFirebase();
                                      final snackBar = SnackBar(
                                        content: Text('Đánh dấu đã học'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Timer(
                                        Duration(seconds: 2),
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.star),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 16 / 10,
              autoPlay: false,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(milliseconds: 3000),
              viewportFraction: 0.9,
              onPageChanged: (index, result) {
                _audioPlayer.stop();
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateProcessToFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection("users").doc(Constants.userId).get();

    final name = documentSnapshot['name'];
    final address = documentSnapshot['address'];
    final email = documentSnapshot['email'];
    List<dynamic> process = documentSnapshot['process'] ?? [];
    List<ProcessItem> _process = process.map((item) {
      return ProcessItem(
        title: item["title"],
        percent: item["percent"],
      );
    }).toList();

    int dataSaveCount = viewmodel.dataSaveCount;
    int vocabulariesLength = widget.vocabularies.length;
    double number = dataSaveCount * 100 / vocabulariesLength;
    String percent = number.round().toString();

    int found = 0;
    for (ProcessItem i in _process) {
      if (i.title == widget.content.title) {
        i.percent = percent + "%";
        found = 1;
        break;
      }
    }

    if (found == 0) {
      _process.add(
          ProcessItem(title: widget.content.title, percent: percent + "%"));
    }

    List<Map<String, String>> listProcess = [];
    for (ProcessItem i in _process) {
      listProcess.add({"percent": i.percent, "title": i.title});
    }

    final data = {
      "name": name,
      "email": email,
      "address": address,
      "process": listProcess,
    };
    await firestore.collection("users").doc(Constants.userId).set(data);
  }
}
