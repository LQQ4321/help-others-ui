import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/pages/home.dart';
import 'package:help_them/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  Config.dio.interceptors.add(RequestInterceptor());

  RootDataModel rootDataModel = RootDataModel();
  rootDataModel.initWebsite();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: rootDataModel),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'help others',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
