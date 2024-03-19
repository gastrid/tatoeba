import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({required this.text, this.pinyin});
  final String text;
  final String? pinyin;

  Text cardText(String text) {
    return Text(
      text, 
      textAlign: TextAlign.center, style: TextStyle(fontSize: 20)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 7,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child:
                pinyin == null ? 
                cardText(text) : 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cardText(text),
                    cardText(pinyin!),
                  ],
                ),
          ),
        ),
    );
  }
}