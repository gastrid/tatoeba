import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/design_texts.dart';
import 'package:tatoeba_trainer/screens/design_colours.dart';
import 'package:tatoeba_trainer/screens/new_sentences.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/screens/saved_sentences.dart';
import 'package:tatoeba_trainer/screens/search_results.dart';

class ModePicker extends StatefulWidget {
  const ModePicker({Key? key, required String this.language}) : super(key: key);

  static const chineseRoute = '/chinese';
  static const russianRoute = '/russian';
  static const chinese = 'chinese';
  static const russian = 'russian';

  final String language;

  @override
  State<ModePicker> createState() => _ModePickerState();
}

class _ModePickerState extends State<ModePicker> {

  Icon customIcon = const Icon(Icons.search);

  bool _searchBoolean = false;

  void switchSearchState() { 
      setState(() {
        if (_searchBoolean == false) {
          _searchBoolean = true;

        } else {
          _searchBoolean = false;
        }
      });       
  }  
  Widget _searchTextField() {
    return TextField(
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: Colors.white,
      onSubmitted: (searchText) {
        Navigator.of(context).push<void>(MaterialPageRoute(
                          builder: ((context) =>
                              SearchResults(language: widget.language, searchString: searchText))));
      },
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration( //Style of TextField
        enabledBorder: UnderlineInputBorder( //Default TextField border
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder( //Borders when a TextField is in focus
          borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle( //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widget_title = (widget.language == ModePicker.chinese ? "Chinese" : "Russian");
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: _searchBoolean ? _searchTextField() : Text(widget_title),
          actions: [
            IconButton(
              onPressed: switchSearchState,
              icon: _searchBoolean ? Icon(Icons.cancel) : Icon(Icons.search),
            )
          ]),
      body: FutureBuilder(
          future: Provider.of<DbProvider>(context).initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text("Pick a mode",
                      style: Theme.of(context).textTheme.displayMedium,),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(MaterialPageRoute(
                          builder: ((context) =>
                              NewSentences(language: widget.language))));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 0),
                      padding: EdgeInsets.all(10.0),
                    ),
                    icon: Icon(Icons.autorenew),
                    label: Text("New Sentences"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push<void>(MaterialPageRoute(
                            builder: ((context) =>
                                SavedSentences(language: widget.language))));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 0),
                        padding: EdgeInsets.all(10.0),
                      ),
                      icon: Icon(Icons.favorite),
                      label: Text("Saved")),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(MaterialPageRoute(
                          builder: ((context) =>
                              DesignTexts())));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 0),
                      padding: EdgeInsets.all(10.0),
                    ),
                    icon: Icon(Icons.autorenew),
                    label: Text("Design fonts"),
                  ),
                                    SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(MaterialPageRoute(
                          builder: ((context) =>
                              DesignColours())));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 0),
                      padding: EdgeInsets.all(10.0),
                    ),
                    icon: Icon(Icons.autorenew),
                    label: Text("Design colours"),
                  ),
                ],
              ));
            }
          }), // This trailing comma makes auto-formatting nicer for build methods.
      
    );
  }
}
