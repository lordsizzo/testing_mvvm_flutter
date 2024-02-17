import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_mvvm_flutter/view/mainview.dart';
import 'package:testing_mvvm_flutter/view_model/mainview_viewmodel.dart';
import 'package:testing_mvvm_flutter/view_model/mainview_viewmodel_online.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonViewModel()),
        ChangeNotifierProvider(create: (_) => ServerViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainView("Testing MVVM"),
    );
  }
}
