import 'package:flutter/material.dart';
import 'package:controls_data/odata_client.dart';

class ODataFuture extends StatelessWidget {
  final Future<dynamic> future;
  final Function(BuildContext, ODataResult) builder;
  final initialData;
  const ODataFuture({Key key, this.initialData, this.future, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: (initialData != null)
          ? {
              "rows": 1,
              "result": [initialData]
            }
          : {"rows": 0, "result": []},
      future: future,
      builder: (context, response) {
        print('retorno:  ${response.data}');
        if (response.hasData) {
          var rst = ODataResult(json: response.data);
          print(rst.data.docs.length);
          return builder(context, rst);
        } else
          return builder(context, ODataResult(json: null));
      },
    );
  }
}
