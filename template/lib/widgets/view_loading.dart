// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:shimmer/shimmer.dart';

class ViewLoading extends StatelessWidget {
  final double width;
  final double height;
  final String? text;
  const ViewLoading({Key? key, this.text, this.width = 200, this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grey = Colors.grey.withOpacity(0.50);
    final ResponsiveInfo responsive = ResponsiveInfo(context);
    return Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.grey.withOpacity(0.26),
        child: ListView(
          children: [
            for (var i = 0; i < responsive.size.height ~/ 60; i++)
              ListTile(
                leading: Container(width: 30, height: 30, color: grey),
                title: Column(
                  children: [
                    for (var n = 0; n < 3; n++)
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                            height: 12, width: double.infinity, color: grey),
                      ),
                  ],
                ),
                //subtitle:
                //    Container(height: 20, width: double.infinity, color: grey),
              ),
          ],
        ));
    //return Align(child: CircularProgressIndicator());
  }
}
