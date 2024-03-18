import 'package:flutter/material.dart';

class DesignColours extends StatelessWidget {
  const DesignColours({Key? key}) : super(key: key);

  static const route = "/design-colours";

  @override
  Widget build(BuildContext context) {
    final colours = [
      ["cardColor", Theme.of(context).cardColor],
      ["dialogBackgroundColor", Theme.of(context).dialogBackgroundColor],
      ["disabledColor", Theme.of(context).disabledColor],
      ["dividerColor", Theme.of(context).dividerColor],
      ["focusColor", Theme.of(context).focusColor],
      ["highlightColor", Theme.of(context).highlightColor],
      ["hintColor", Theme.of(context).hintColor],
      ["hoverColor", Theme.of(context).hoverColor],
      ["indicatorColor", Theme.of(context).indicatorColor],
      ["primaryColor", Theme.of(context).primaryColor],
      ["primaryColorDark", Theme.of(context).primaryColorDark],
      ["primaryColorLight", Theme.of(context).primaryColorLight],
      ["scaffoldBackgroundColor", Theme.of(context).scaffoldBackgroundColor],
      ["secondaryHeaderColor", Theme.of(context).secondaryHeaderColor],
      ["shadowColor", Theme.of(context).shadowColor],
      ["splashColor", Theme.of(context).splashColor],
      ["unselectedWidgetColor", Theme.of(context).unselectedWidgetColor],
      ["canvasColor", Theme.of(context).canvasColor],
      ["primary", Theme.of(context).colorScheme.primary],
      ["onPrimary", Theme.of(context).colorScheme.onPrimary],
      ["secondary", Theme.of(context).colorScheme.secondary],
      ["onSecondary", Theme.of(context).colorScheme.onSecondary],
      ["error", Theme.of(context).colorScheme.error],
      ["onError", Theme.of(context).colorScheme.onError],
      ["background", Theme.of(context).colorScheme.background],
      ["onBackground", Theme.of(context).colorScheme.onBackground],
      ["surface", Theme.of(context).colorScheme.surface],
      ["onSurface", Theme.of(context).colorScheme.onSurface],
    ];
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Colours"),
        ),
        body: 
          ListView.builder(
            scrollDirection: Axis.vertical,
    shrinkWrap: true,
            padding: EdgeInsets.all(20),
            itemCount: colours.length,
            itemBuilder: ((context, index) {
              return Container(
                height: 60,
                key: Key(index.toString()),
                color: colours[index][1] as Color,
                child: Column(
                  children: [
                    Text(colours[index][0] as String),
                    Text((colours[index][1] as Color).opacity.toString()),
                  ],
                ),
              );
            }),
          )
        );
  }
}
