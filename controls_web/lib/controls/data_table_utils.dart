import 'package:flutter/material.dart';

import 'data_table.dart';

DataTitleX(String label, {void Function(int, bool) onSort}) {
  return DataColumnX(
      label: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      onSort: onSort);
}
