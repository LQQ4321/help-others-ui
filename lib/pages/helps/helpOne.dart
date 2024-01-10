import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';

class HelpOne extends StatelessWidget {
  const HelpOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  Config.openLink('https://github.com/LQQ4321/help-others');
                },
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size(100, 50))),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Github.com',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.link, color: Colors.black)
                  ],
                )),
          ),
          Column(
              children:
                  List.generate(ConstantData.whyHelpOthers.length, (index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.question_mark,
                          color: Colors.grey, size: 15),
                    ),
                    const SizedBox(width: 20),
                    Center(
                        child: Text(ConstantData.whyHelpOthers[index],
                            maxLines: 10))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.question_answer,
                          size: 15, color: Colors.grey),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(ConstantData.answerHelpOthers[index],
                                maxLines: 10)))
                  ],
                ),
                const SizedBox(height: 50)
              ],
            );
          }))
        ],
      ),
    );
  }
}
