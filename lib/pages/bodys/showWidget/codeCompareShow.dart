import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class ScrollSyncWidget extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll Sync Example'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      child: Text('Item $index'),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      child: Text('Item $index'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ScrollSyncWidget(),
  ));
}

class MyHomePage extends StatelessWidget {
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 20;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScrollbar(
        controller: verticalScroll,
        width: width,
        scrollToClickDelta: 75,
        scrollToClickFirstDelay: 200,
        scrollToClickOtherDelay: 50,
        sliderDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        sliderActiveDecoration: BoxDecoration(
            color: Color.fromRGBO(206, 206, 206, 100),
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        underColor: Colors.transparent,
        child: Row(
          children: [
            Expanded(child: AdaptiveScrollbar(
                underSpacing: EdgeInsets.only(bottom: width),
                controller: horizontalScroll,
                width: width,
                position: ScrollbarPosition.bottom,
                sliderDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                sliderActiveDecoration: BoxDecoration(
                    color: Color.fromRGBO(206, 206, 206, 100),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                underColor: Colors.transparent,
                child: SingleChildScrollView(
                    controller: horizontalScroll,
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        width: 3000,
                        child: Scaffold(
                          appBar: AppBar(
                              title: Text("Example",
                                  style: TextStyle(color: Colors.black)),
                              flexibleSpace: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blueAccent,
                                            Color.fromRGBO(208, 206, 255, 1)
                                          ])))),
                          body: Container(
                              color: Colors.lightBlueAccent,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: width),
                                  controller: verticalScroll,
                                  itemCount: 100,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 30,
                                      color: Colors.lightBlueAccent,
                                      child: Text("Line " + index.toString()),
                                    );
                                  })),
                        )))))
          ],
        ));
  }
}

class CodeCompareShow extends StatefulWidget {
  const CodeCompareShow({Key? key}) : super(key: key);

  @override
  State<CodeCompareShow> createState() => _CodeCompareShowState();
}

class _CodeCompareShowState extends State<CodeCompareShow> {
  final ScrollController _hCtrl1 = ScrollController();
  final ScrollController _hCtrl2 = ScrollController();

  final ScrollController _vCtrl = ScrollController();

  final ScrollController _vCtrl1 = ScrollController();
  final ScrollController _vCtrl2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _vCtrl1.addListener(_scrollListener);
    _vCtrl2.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _hCtrl1.dispose();
    _hCtrl2.dispose();
    _vCtrl.dispose();
    _vCtrl1.removeListener(_scrollListener);
    _vCtrl2.removeListener(_scrollListener);
    _vCtrl1.dispose();
    _vCtrl2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text = 'Hello World' * 500;
    const TextStyle style =
        TextStyle(fontSize: 16, color: Colors.grey, letterSpacing: 1);
    return Scrollbar(
      thumbVisibility: true,
      notificationPredicate: (ScrollNotification notification) =>
          notification.depth == 1,
      key: const Key('debuggerCodeViewVerticalScrollbarKey'),
      controller: _vCtrl,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double boxWidth = FunctionOne.calculateText(text, style);
            return Row(
              children: [
                Expanded(
                    child: Scrollbar(
                        key: const Key(
                            'debuggerCodeViewHorizontalScrollbarKey1'),
                        thumbVisibility: true,
                        controller: _hCtrl1,
                        child: SingleChildScrollView(
                          controller: _hCtrl1,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: constraints.maxHeight,
                            width: max(boxWidth, constraints.maxWidth / 2),
                            child: SingleChildScrollView(
                              controller: _vCtrl,
                              child: Container(
                                color: Colors.blue,
                                child: Column(
                                  children: List.generate(
                                      100, (index) => Text(text, style: style)),
                                ),
                              ),
                            ),
                          ),
                        ))),
                Expanded(
                  child: Scrollbar(
                      key: const Key('debuggerCodeViewHorizontalScrollbarKey2'),
                      thumbVisibility: true,
                      controller: _hCtrl2,
                      child: SingleChildScrollView(
                        controller: _hCtrl2,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: constraints.maxHeight,
                          width: max(boxWidth, constraints.maxWidth / 2),
                          child: SingleChildScrollView(
                            controller: _vCtrl,
                            child: Container(
                              color: Colors.red,
                              child: Column(
                                children: List.generate(
                                    100, (index) => Text(text, style: style)),
                              ),
                            ),
                          ),
                        ),
                      )),
                )
              ],
            );

            //   Row(
            //   children: [
            //     Expanded(
            //         child: Scrollbar(
            //             key: const Key(
            //                 'debuggerCodeViewHorizontalScrollbarKey1'),
            //             thumbVisibility: true,
            //             controller: _hCtrl1,
            //             child: SingleChildScrollView(
            //               controller: _hCtrl1,
            //               scrollDirection: Axis.horizontal,
            //               child: SizedBox(
            //                 height: constraints.maxHeight,
            //                 width: max(boxWidth, constraints.maxWidth / 2),
            //                 child: SingleChildScrollView(
            //                   controller: _vCtrl1,
            //                   child: Container(
            //                     color: Colors.blue,
            //                     height: boxHeight,
            //                     child: Column(
            //                       children: List.generate(
            //                           100, (index) => Text(text, style: style)),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ))),
            //     Expanded(
            //       child: Scrollbar(
            //           key: const Key('debuggerCodeViewHorizontalScrollbarKey2'),
            //           thumbVisibility: true,
            //           controller: _hCtrl2,
            //           child: SingleChildScrollView(
            //             controller: _hCtrl2,
            //             scrollDirection: Axis.horizontal,
            //             child: SizedBox(
            //               height: constraints.maxHeight,
            //               width: max(boxWidth, constraints.maxWidth / 2),
            //               child: SingleChildScrollView(
            //                 controller: _vCtrl2,
            //                 child: Container(
            //                   color: Colors.red,
            //                   height: boxHeight,
            //                   child: Column(
            //                     children: List.generate(
            //                         100, (index) => Text(text, style: style)),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )),
            //     )
            //   ],
            // );
          },
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_vCtrl1.position.userScrollDirection == ScrollDirection.reverse) {
      _vCtrl2.jumpTo(_vCtrl1.offset);
    } else if (_vCtrl1.position.userScrollDirection ==
        ScrollDirection.forward) {
      _vCtrl2.jumpTo(_vCtrl1.offset);
    } else if (_vCtrl2.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _vCtrl1.jumpTo(_vCtrl2.offset);
    } else if (_vCtrl2.position.userScrollDirection ==
        ScrollDirection.forward) {
      _vCtrl1.jumpTo(_vCtrl2.offset);
    }
  }
}
