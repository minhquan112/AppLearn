import 'package:learning_app/features/home/model/Vocabulary.dart';

class Content {
  String title;
  String image;
  List<Vocabulary> vocabulary;

  Content({
    required this.title,
    required this.image,
    List<Vocabulary>? listVoca,
  }) : this.vocabulary = listVoca ?? [];
}
