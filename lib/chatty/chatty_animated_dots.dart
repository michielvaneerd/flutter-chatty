import 'dart:async';

import 'package:flutter/material.dart';

class ChattyAnimatedDots extends StatefulWidget {
  const ChattyAnimatedDots({super.key, this.textStyle});
  final TextStyle? textStyle;

  @override
  State<ChattyAnimatedDots> createState() => _ChattyAnimatedDotsState();
}

class _ChattyAnimatedDotsState extends State<ChattyAnimatedDots> {
  late Timer _timer;
  int counter = 0;
  static const maxCount = 5;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if (counter == maxCount) {
          counter = 0;
        } else {
          counter += 1;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(List.filled(counter, '.').join(''), style: widget.textStyle);
    // return Row(
    //   spacing: 10,
    //   mainAxisSize: MainAxisSize.min,
    //   children: counter == 0
    //       ? [SizedBox(height: 10)]
    //       : List<Container>.generate(counter, (i) {
    //           return Container(
    //             width: 10,
    //             height: 10,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(4),
    //               color: Colors.black.withAlpha(80),
    //             ),
    //           );
    //         }),
    // );
  }
}
