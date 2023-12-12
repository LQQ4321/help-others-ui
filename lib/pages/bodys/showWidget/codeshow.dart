import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:provider/provider.dart';

class CodeShow extends StatefulWidget {
  const CodeShow({Key? key}) : super(key: key);

  @override
  State<CodeShow> createState() => _CodeShowState();
}

class _CodeShowState extends State<CodeShow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopBar(),
        Container(
            height: 1,
            color: Colors.black12,
            margin: const EdgeInsets.only(bottom: 10)),
        const Expanded(child: _SeekHelpCodeShow())
      ],
    );
  }
}

class _SeekHelpCodeShow extends StatelessWidget {
  const _SeekHelpCodeShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> codeContext =
        context.watch<RootDataModel>().lendHandModel.showInfo.codeContent;
    return ListView.builder(
        itemCount: codeContext.length,
        itemExtent: 20,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Text(codeContext[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey)))
            ],
          );
        });
  }
}

// class _CodeTextShow extends StatelessWidget {
//   const _CodeTextShow({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> codeContext =
//         context.watch<RootDataModel>().lendHandModel.showInfo.codeContent;
//     codeContext.addAll(List.generate(100, (index) => 'Hello World' * index));
//     return ListView.builder(
//         itemBuilder: (BuildContext context, int index) {
//           return LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               final double maxLineWidth = constraints.maxWidth;
//               final List<String> lines = FunctionOne.splitTextIntoLines(
//                   context, codeContext[index], maxLineWidth - 50);
//               // debugPrint(maxLineWidth.toString() + 'hello');
//               // debugPrint(lines.length.toString() + 'world');
//               // debugPrint(constraints.toString());
//               //小心某些行为空的情况
//               debugPrint('$index - ${lines.length}');
//               return SizedBox(
//                   height: 20 + (lines.length > 1 ? lines.length - 1 : 0) * 40,
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 40,
//                         child: Align(
//                           alignment: Alignment.topRight, //这里先暂时不考虑一行放不下的情况
//                           child: Text('${index + 1}',
//                               style: const TextStyle(color: Colors.grey)),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                           child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: lines.map((e) {
//                           return Text(e,
//                               style: const TextStyle(color: Colors.grey));
//                         }).toList(),
//                       ))
//                     ],
//                   ));
//
//               Row(
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight, //这里先暂时不考虑一行放不下的情况
//                     child: Text('${index + 1}',
//                         style: const TextStyle(color: Colors.grey)),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: lines.map((e) {
//                       return Text(e,
//                           style: const TextStyle(color: Colors.grey));
//                     }).toList(),
//                   ))
//                 ],
//               );
//             },
//           );
//           Row(
//             children: [
//               SizedBox(
//                 width: 40,
//                 height: double.infinity,
//                 child: Align(
//                   alignment: Alignment.centerRight, //这里先暂时不考虑一行放不下的情况
//                   child: Text('${index + 1}',
//                       style: const TextStyle(color: Colors.grey)),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(child: LayoutBuilder(
//                 builder: (BuildContext context, BoxConstraints constraints) {
//                   final double maxLineWidth = constraints.maxWidth;
//                   final List<String> lines = FunctionOne.splitTextIntoLines(
//                       context, codeContext[index], maxLineWidth);
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: lines.map((e) {
//                       return Text(e,
//                           style: const TextStyle(color: Colors.grey));
//                     }).toList(),
//                   );
//                 },
//               ))
//             ],
//           );
//         },
//         itemCount: codeContext.length);
//   }
// }

class _TopBar extends StatefulWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  @override
  Widget build(BuildContext context) {
    final codeLines = context
        .watch<RootDataModel>()
        .lendHandModel
        .showInfo
        .codeContent
        .length;
    String codeText = context
        .watch<RootDataModel>()
        .lendHandModel
        .showInfo
        .codeContent
        .join('\n');
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), topLeft: Radius.circular(8))),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$codeLines lines', style: const TextStyle(color: Colors.grey)),
          ClipOval(
              child: Center(
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Builder(
                        builder: (context) {
                          return TextButton(
                              onPressed: () async {
                                ToastOne.smallTip(context, 'Copied');
                                Clipboard.setData(
                                    ClipboardData(text: codeText));
                              },
                              child: const Icon(Icons.copy,
                                  size: 20, color: Colors.grey));
                        },
                      ))))
        ],
      ),
    );
  }
}
