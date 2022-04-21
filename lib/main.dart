import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature_screen.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Signature';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: MyHomePage(),
      );
}

class Tes extends StatefulWidget {
  const Tes({Key? key}) : super(key: key);

  @override
  State<Tes> createState() => _TesState();
}

class _TesState extends State<Tes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(
          File('/storage/emulated/0/Pictures/signature_264.png.jpg')),
    );
  }
}
