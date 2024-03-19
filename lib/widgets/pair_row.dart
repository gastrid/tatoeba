import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/sentence.dart';
import 'package:lpinyin/lpinyin.dart';

class PairRow extends StatelessWidget {
  const PairRow(
      {Key? key,
      required this.sourceSentence,
      required this.targetSentence,
      required this.language})
      : super(
          key: key,
        );
  final String sourceSentence;
  final String targetSentence;
  final String language;

  @override
  Widget build(BuildContext context) {
    final textHeight = Theme.of(context).textTheme.titleLarge!.fontSize;
    print("textHeight: ${textHeight}");
    final pinyin = language == "chinese"
        ? PinyinHelper.getPinyin(targetSentence,
                format: PinyinFormat.WITH_TONE_MARK)
            .trim()
        : null;
    print(targetSentence);
    print(sourceSentence);

    

    final theme = Theme.of(context);

    final deviceSize = MediaQuery.of(context).size;
    return 
    Container(
      margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      child: ListTile(
        tileColor: theme.focusColor,
        onTap: () {},
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            sourceSentence,
            style:
                theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.normal
                ),
          ),
        ),
        subtitle: pinyin == null
            ? Text(
                targetSentence,
                style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
                // fontWeight: FontWeight.bold,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // There's a weird new line at the end of every chinese sentence
                    targetSentence.trim(),
                    style: theme.textTheme.headlineSmall!.copyWith(
                        // fontFamily: "NotoSerifChinese",
                        color: theme.colorScheme.primary,
                        // fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  // ),
                  Text(
                    pinyin,
                    style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.normal
                        ),
                  )
                ],
              ),
      ),
    );
    // Card(
    //   child: Container(
    //     width: deviceSize.width,
    //     child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(
    //             sourceSentence,
    //             style: Theme.of(context).textTheme.titleLarge!.copyWith(
    //                 fontWeight: FontWeight.bold),
    //           ),
    //           // Expanded(
    //           //   flex: 4,
    //           //   child:
    //           pinyin == null
    //               ? Container(
    //                   // constraints: BoxConstraints(maxHeight: 50),
    //                   child: Text(
    //                   targetSentence,
    //                   style: Theme.of(context)
    //                       .textTheme
    //                       .titleLarge!
    //                       .copyWith(
    //                           color: Theme.of(context).hintColor,
    //                           fontWeight: FontWeight.bold),
    //                 ))
    //               : Container(
    //                   // constraints:
    //                   // BoxConstraints(maxHeight: 100, minHeight: 50),
    //                   child: Flexible(
    //                     child: Text("${targetSentence} ${pinyin}",
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                               color: Theme.of(context).hintColor,
    //                             )),
    //                   ),
    //                 ),
    //           // ),
    //           Divider(
    //             height: 1,
    //           )
    //         ]),
    //   ),
    // );
  }
}
