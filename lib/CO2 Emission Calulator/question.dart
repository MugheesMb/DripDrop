import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText1;
  final String questionText2;
  final String questionText3;
  const Question(this.questionText1, this.questionText2, this.questionText3, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, top: 50, bottom: 100),
      child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  text: (questionText1),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                  children: [
                    TextSpan(
                      text: (questionText2),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                  text: (questionText3),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),),
                  ],),
            ),
    );
  }
}
