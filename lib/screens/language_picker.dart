import 'package:flutter/material.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final image_width = deviceSize.width / 3;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    Text buttonText(String text) {
      return Text(text,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20));
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Tatoeba trainer"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Pick a language",
                      style: Theme.of(context).textTheme.headline3),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/russian");
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(20.0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(right: 20),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child:
                                Image.asset("assets/images/russian-flag.jpeg",
                                    // width: image_width,
                                    alignment: Alignment.bottomLeft,
                                    fit: BoxFit.cover),
                          ),
                          buttonText("Russian")
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/chinese");
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(20.0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(right: 20),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset("assets/images/chinese-flag.png",
                                // width: image_width,
                                alignment: Alignment.bottomLeft,
                                fit: BoxFit.cover),
                          ),
                          buttonText("Chinese")
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
