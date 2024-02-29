import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/review_saved_sentences.dart';
import 'review_search_results.dart';
import 'package:tatoeba_trainer/widgets/pair_row.dart';
import 'package:tatoeba_trainer/widgets/flashcard_scroller.dart';

class SearchResults extends StatefulWidget {
  const SearchResults(
      {Key? key, required this.language, required this.searchString})
      : super(key: key);

  final String language;
  final String searchString;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late List<FlashcardSentence> _sentences;

  final controller = ScrollController();
  var _isInit = true;
  var _isLoading = false;
  var _hasMore = true;

  @override
  void initState() {
    super.initState();
    // This is run when reaching the bottom
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        Provider.of<DbProvider>(context, listen: false)
            .searchEnglish(
              widget.language,
              widget.searchString,
              false,
              limit: 10,
            )
            .then((value) => _hasMore = value);
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit && mounted) {
      setState(() {
        _isLoading = true;
      });
      // This is run at the start
      Provider.of<DbProvider>(context, listen: false)
          .searchEnglish(widget.language, widget.searchString, true)
          .then((hasMore) {
        setState(() {
          _hasMore = hasMore;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("search page entered");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Search results"),
      ),
      body: _isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()))
          : Selector<DbProvider, int>(
              selector: (_, db) => db.search_sentence_count,
              builder: (context, value, child) {
                return ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  itemCount: value + 1,
                  itemBuilder: ((context, index) {
                    print("inside itemBuilder");
                    print(" index: ${index}, value: ${value}");
                    if (index < value) {
                      final search_sentences =
                          Provider.of<DbProvider>(context, listen: false)
                              .search_sentences;
                      final sentence = search_sentences[index];
                      // return ListTile(title:
                      // Text(sentence.source.sentence));
                      return PairRow(
                          sourceSentence: sentence.source.sentence,
                          targetSentence: sentence.target.sentence,
                          language: widget.language);
                    } else {
                      return _hasMore
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(child: CircularProgressIndicator()))
                          : Container();
                    }
                  }),
                );
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu_book),
        onPressed: () {
          Navigator.of(context).push<void>(MaterialPageRoute(
              builder: ((context) => ReviewSearchResults(
                  language: widget.language,
                  sentences: Provider.of<DbProvider>(context, listen: false)
                      .search_sentences))));
        },
      ),
    );
  }
}
