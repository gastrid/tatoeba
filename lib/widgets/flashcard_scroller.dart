import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:tatoeba_trainer/widgets/reuseable_card.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import './flashcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_controller.dart';

import '../models/flashcardSentence.dart';
import 'package:flutter/material.dart';

class FlashcardScroller extends StatefulWidget {
  const FlashcardScroller(
      {Key? key,
      required List<FlashcardSentence> this.sentences,
      this.isChinese = false})
      : super(key: key);
  final List<FlashcardSentence> sentences;
  final bool isChinese;
  @override
  _FlashcardScrollerState3 createState() => _FlashcardScrollerState3();
}

enum SwipeDirection { left, right }

class _FlashcardScrollerState3 extends State<FlashcardScroller>
    with TickerProviderStateMixin {
  int _index = 0;
  late FlashcardSentence _currentCard;
  double _progressValue = 0.1;
  SwipeDirection swipeDirection = SwipeDirection.left;
  late double _dragStartPosition;
  late int _deckLength;

  final Widget divider = SizedBox(height: 40);

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(right: 20, left: 25, top: 15, bottom: 15));

  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _deckLength = widget.sentences.length;
    _currentCard = widget.sentences[0];
  }

  void _updateProgressValue() {
    _progressValue = (_index + 1) / _deckLength;
  }

  void _toggleSaved(int id, bool saved) {
    setState(() {
      _currentCard.target.saved = !saved;
    });
    if (!saved) {
      Provider.of<DbProvider>(context, listen: false).saveSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unsaveSentence(id);
    }
  }

  void _toggleHide(int id, bool hidden) {
    setState(() {
      _currentCard.target.hide = !hidden;
    });
    if (!hidden) {
      Provider.of<DbProvider>(context, listen: false).hideSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unhideSentence(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _deckLength > 0
        ? GestureDetector(
            child: Column(children: [
              divider,
              Container(
                child: CarouselSlider.builder(
                  itemCount: _deckLength,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return Flashcard(
                        key: ValueKey<int>(itemIndex),
                        sentence: widget.sentences[itemIndex],
                        isChinese: widget.isChinese);
                  },
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 0.9,
                    animateToClosest: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCard = widget.sentences[index];
                        _index = index;
                        _updateProgressValue();
                      });
                    },
                  ),
                ),
              ),
              divider,
              Text("Question ${_index + 1} of $_deckLength completed"),
              divider,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary),
                    minHeight: 10,
                    value: _progressValue, // TODO: change
                  ),
                ),
              ),
              divider,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 80,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            _toggleSaved(_currentCard.target.id,
                                _currentCard.target.saved);
                          },
                          icon: _currentCard.target.saved
                              ? Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border, size: 30),
                          label: Text(""),
                          style: buttonStyle),
                    ),
                    Container(
                      width: 150,
                      height: 80,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            _toggleHide(_currentCard.target.id, false);
                          },
                          icon: _currentCard.target.hide
                              ? Icon(Icons.not_interested,
                                  size: 30, color: Colors.black)
                              : Icon(Icons.not_interested, size: 30),
                          label: Text(""),
                          style: buttonStyle),
                    )
                  ])
            ]),
          )
        : Text("no sentences");
  }
}
