import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AsymmetricView extends StatelessWidget {
  final int count;
  final Widget Function(BuildContext, int) builder;
  AsymmetricView({Key key, @required this.builder, this.count = 0});

  List<Widget> _buildColumns(context) {
    return List.generate(count, (int index) {
      return builder(context, index);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var items = _buildColumns(context);
    return Wrap(runSpacing: 0, children: items);
  }
}
