import 'package:flutter/material.dart';

class DashboardDensedTile extends StatefulWidget {
  final double? elevation;

  final double? height;

  final double? width;

  final Color? color;

  const DashboardDensedTile(
      {Key? key, this.elevation = 10, this.height, this.width, this.color})
      : super(key: key);

  @override
  _DashboardDensedTileState createState() => _DashboardDensedTileState();
}

class _DashboardDensedTileState extends State<DashboardDensedTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      color: widget.color,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
