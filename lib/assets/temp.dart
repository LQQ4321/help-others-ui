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
// 在上述示例中，使用 `shared_preferences` 插件来实现本地存储功能。在应用程序初始化时，从本地存储中读取当前路由，然后在每次路由变化时将当前路由信息保存到本地存储中。