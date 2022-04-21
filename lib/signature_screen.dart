import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  Image? loadImageFromFile(String path) {
    File file = new File(path);
    Image img = Image.file(file);
    print('ini adalah image${img}');
  }

  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase!;
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState?.clear();
  }

  

  void _handleSaveButtonPressed() async {
    RenderSignaturePad boundary = signatureGlobalKey.currentContext
        ?.findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: name,
          isReturnImagePathOfIOS: true);
      print(result);
      loadImageFromFile('/storage/emulated/0/Pictures/signature_81.png.jpg');
      _toastInfo(result.toString());
      uploadImage('/storage/emulated/0/Pictures/${name}.jpg',
          "http://192.168.0.7:3000/api/event");
      final isSuccess = result['isSuccess'];

      signatureGlobalKey.currentState?.clear();
      if (isSuccess) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Container(
                    color: Colors.grey[300],
                    child: Image.memory(byteData.buffer.asUint8List()),
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(info),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                child: SfSignaturePad(
                    key: signatureGlobalKey,
                    backgroundColor: Colors.white,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 3.0,
                    maximumStrokeWidth: 6.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)))),
        SizedBox(height: 10),
        Row(children: <Widget>[
          TextButton(
            child: Text(
              'Save As Image',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: _handleSaveButtonPressed,
          ),
          TextButton(
            child: Text('Clear', style: TextStyle(fontSize: 20)),
            onPressed: _handleClearButtonPressed,
          )
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
      ],
    ));
  }
}
