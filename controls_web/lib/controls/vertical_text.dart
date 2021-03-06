import 'package:flutter/widgets.dart';

class VerticalText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final double? runSpacing;
  const VerticalText(
    this.text, {
    Key? key,
    this.style,
    this.runSpacing = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: runSpacing!,
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        children: [
          ...text!.split("").map((string) => Text(string, style: style)),
        ]);
  }
}
