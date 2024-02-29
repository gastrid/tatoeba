import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/widgets/flashcard_scroller.dart';



class ReviewSearchResults extends StatefulWidget {
  const ReviewSearchResults({ Key? key, required this.language, required this.sentences }) : super( key: key);

  final String language;
  final List<FlashcardSentence> sentences;

  @override
  _ReviewSearchResultsState createState() => _ReviewSearchResultsState();
}

class _ReviewSearchResultsState extends State<ReviewSearchResults> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Flashcards"),
      ),
      body: FlashcardScroller(sentences: widget.sentences, isChinese: widget.language == "chinese",)// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}