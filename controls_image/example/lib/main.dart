import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:controls_image/controls_image.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
                ? Card(child: Image.memory(imagem!))
                : Card(child: Text('nada ainda ${count.value}'))
          ],
        ),
      ),
    );
  }
}
