import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:controls_image/controls_image.dart';

import 'package:controls_image/image_view/image_editor_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageEditorView(
        useFilter: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? imagem;
  late ValueNotifier<int> count;
  @override
  void initState() {
    super.initState();
    count = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Exemplo'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                ImagePicker().pickFromGallary().then((rsp) {
                  setState(() {
                    imagem = rsp;
                    count.value = count.value + 1;
                  });
                });
              })
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: count,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Text('$value');
              },
            ),
            (imagem != null)
                ? Card(
                    child: Image.memory(imagem!),
                  )
                : Card(child: Text('nada ainda ${count.value}'))
          ],
        ),
      ),
    );
  }
}
