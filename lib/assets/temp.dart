// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late String currentRoute;
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     initializeApp();
//   }
//
//   Future<void> initializeApp() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     currentRoute = prefs.getString('currentRoute') ?? '/';
//   }
//
//   Future<void> saveCurrentRoute(String route) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('currentRoute', route);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       navigatorKey: navigatorKey,
//       initialRoute: currentRoute,
//       onGenerateRoute: (settings) {
//         return MaterialPageRoute(
//           builder: (context) {
//             return Navigator(
//               key: navigatorKey,
//               onGenerateRoute: (settings) {
//                 return MaterialPageRoute(
//                   builder: (context) {
//                     saveCurrentRoute(settings.name!);
//                     return getWidgetForRoute(settings.name!);
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget getWidgetForRoute(String route) {
//     switch (route) {
//       case '/':
//         return HomePage();
//       case '/second':
//         return SecondPage();
//       default:
//         return HomePage();
//     }
//   }
// }
// ```
//
// 在上述示例中，使用 `shared_preferences` 插件来实现本地存储功能。在应用程序初始化时，从本地存储中读取当前路由，然后在每次路由变化时将当前路由信息保存到本地存储中
//
//
/*
* Scrollbar(
        thumbVisibility: true,
        notificationPredicate: (ScrollNotification notification) =>
            notification.depth == 1,
        key: const Key('debuggerCodeViewVerticalScrollbarKey'),
        controller: _vCtrl,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double boxHeight = 2500;
            double boxWidth = FunctionOne.calculateText(text, style);
            return Scrollbar(
                key: const Key('debuggerCodeViewHorizontalScrollbarKey'),
                thumbVisibility: true,
                controller: _hCtrl,
                child: SingleChildScrollView(
                  controller: _hCtrl,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: constraints.maxHeight,
                    width: max(boxWidth, constraints.maxWidth),
                    child: SingleChildScrollView(
                      controller: _vCtrl,
                      child: Container(
                        color: Colors.blue,
                        height: boxHeight,
                        child: Text(text, style: style),
                      ),
                    ),
                  ),
                ));
          },
        ));
* */

/*
class _CodeCompareShowState extends State<CodeCompareShow> {
  final ScrollController _hCtrl1 = ScrollController();
  final ScrollController _hCtrl2 = ScrollController();
  final ScrollController _vCtrl = ScrollController();

  @override
  void dispose() {
    _hCtrl1.dispose();
    _hCtrl2.dispose();
    _vCtrl.dispose();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double boxHeight = 2500;
            double boxWidth = FunctionOne.calculateText(text, style);
            return Container(
              child: Row(
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
                                  height: boxHeight,
                                  child: Text(text, style: style),
                                ),
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Scrollbar(
                          key: const Key(
                              'debuggerCodeViewHorizontalScrollbarKey2'),
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
                                  height: boxHeight,
                                  child: Text(text, style: style),
                                ),
                              ),
                            ),
                          )))
                ],
              ),
            );
          },
        ));
  }
}

* */


//=======================================================================
/*
class _CodeCompareShowState extends State<CodeCompareShow> {
  final ScrollController _hCtrl1 = ScrollController();
  final ScrollController _hCtrl2 = ScrollController();

  // final ScrollController _vCtrl = ScrollController();

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
    // _vCtrl.dispose();
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
      controller: _vCtrl1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxHeight = 2500;
          double boxWidth = FunctionOne.calculateText(text, style);
          return Container(
            child: Row(
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
                              controller: _vCtrl1,
                              child: Container(
                                color: Colors.blue,
                                height: boxHeight,
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
                            controller: _vCtrl2,
                            child: Container(
                              color: Colors.red,
                              height: boxHeight,
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
            ),
          );
        },
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
* */