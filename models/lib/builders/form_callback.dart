import 'package:flutter/widgets.dart';

typedef FormChildCallback(BuildContext context, Function(dynamic rsp) callback);
typedef Future<Map<String, dynamic>> FormSearchCallback(BuildContext context);
typedef Future<Map<String, dynamic>> FormValueCallback(
    BuildContext context, Map<String, dynamic> value);
