import 'package:flutter/material.dart';

class ExpansionItem {
  String title;
  Widget body;
  bool isExpanded;
  Color? backgroundColor;
  TextStyle? titleStyle;
  ExpansionItem(
      {required this.title,
      required this.body,
      this.isExpanded = false,
      this.backgroundColor,
      this.titleStyle});
}

class ExpansionGroup extends StatefulWidget {
  final List<ExpansionItem> children;
  final int initialExpandedIndex;
  final double elevation;
  final bool exclusive;
  const ExpansionGroup({
    Key? key,
    this.initialExpandedIndex = 0,
    required this.children,
    this.elevation = 0,
    this.exclusive = false,
  }) : super(key: key);

  @override
  State<ExpansionGroup> createState() => _ExpansionGroupState();
}

class _ExpansionGroupState extends State<ExpansionGroup> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: widget.elevation,
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          if (widget.exclusive) {
            for (var child in widget.children) {
              child.isExpanded = false;
            }
          }
          widget.children[index].isExpanded = !isExpanded;

          /// count the number of expanded items and set the initialExpandedIndex if count equal 0
          int count = 0;
          for (var child in widget.children) {
            if (child.isExpanded) {
              count++;
            }
          }
          if (count == 0) {
            widget.children[widget.initialExpandedIndex].isExpanded = true;
          }
        });
      },
      children: widget.children.map((ExpansionItem choice) {
        return ExpansionPanel(
          backgroundColor: choice.backgroundColor,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                choice.title,
                style: choice.titleStyle,
              ),
            );
          },
          body: choice.body,
          isExpanded: choice.isExpanded,
        );
      }).toList(),
      //  initialOpenPanelValue: children[initialExpandedIndex].isExpanded,
    );
  }
}
