import 'package:flutter/material.dart';
import 'package:record_time_mcfil4/tela_abertura.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SplashScreen',
      theme: ThemeData(

      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new SplashPage()
      },
    );
  }
}