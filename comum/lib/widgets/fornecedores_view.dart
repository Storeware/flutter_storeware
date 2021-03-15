import 'package:flutter/material.dart';

class FornecedoresViewList extends StatefulWidget {
  FornecedoresViewList({Key? key}) : super(key: key);

  @override
  _FornecedoresViewListState createState() => _FornecedoresViewListState();
}

class _FornecedoresViewListState extends State<FornecedoresViewList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fornecedores')),
      body: Container(),
    );
  }
}
