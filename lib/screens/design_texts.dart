import 'package:flutter/material.dart';

class DesignTexts extends StatelessWidget {
  const DesignTexts({Key? key}) : super(key: key);

  static const route = "/design-texts";

  @override
  Widget build(BuildContext context) {
    final texts = [
    ["displayLarge", Theme.of(context).textTheme.displayLarge],
    ["displayMedium", Theme.of(context).textTheme.displayMedium],
    ["displaySmall", Theme.of(context).textTheme.displaySmall],
    ["headlineLarge", Theme.of(context).textTheme.headlineLarge],
    ["headlineMedium", Theme.of(context).textTheme.headlineMedium],
    ["headlineSmall", Theme.of(context).textTheme.headlineSmall],
    ["titleLarge", Theme.of(context).textTheme.titleLarge],
    ["titleMedium", Theme.of(context).textTheme.titleMedium],
    ["titleSmall", Theme.of(context).textTheme.titleSmall],
    ["bodyLarge", Theme.of(context).textTheme.bodyLarge],
    ["bodyMedium", Theme.of(context).textTheme.bodyMedium],
    ["bodySmall", Theme.of(context).textTheme.bodySmall],
    ["labelLarge", Theme.of(context).textTheme.labelLarge],
    ["labelMedium", Theme.of(context).textTheme.labelMedium],
    ["labelSmall", Theme.of(context).textTheme.labelSmall],
    
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
            itemCount: texts.length,
            itemBuilder: ((context, index) {
              return Container(
                key: Key(index.toString()),
                child: Text(
                  texts[index][0] as String,
                  style: texts[index][1] as TextStyle,),
              );
            }),
          )
        );
  }
}
