import 'package:flutter/material.dart';

///  ListBox(
///              title: const Text('ListBox'),
///              children: const ['amarelo', 'verde', 'azul'],
///              values: const [true, false, false],
///              onChanged: (
///                index,
///                value,
///              ) {}),
class ListBox extends StatefulWidget {
  const ListBox({
    Key? key,
    this.color,
    this.title,
    required this.children,
    this.values,
    this.onChanged,
    this.heigth,
    this.itemHeight = 32.0,
    this.dividerColor,
  }) : super(key: key);
  final Color? dividerColor;
  final double itemHeight;
  final Color? color;
  final Widget? title;
  final List<String> children;
  final List<bool>? values;
  final double? heigth;
  final Function(int index, String value)? onChanged;

  @override
  State<ListBox> createState() => _ListBoxState();
}

class _ListBoxState extends State<ListBox> {
  late Map<String, bool> values;
  @override
  void initState() {
    super.initState();
    values = {};
    if (widget.values != null) {
      for (var i = 0; i < widget.children.length; i++) {
        values[widget.children[i]] =
            (i < widget.values!.length ? widget.values![i] : false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          DefaultTextStyle(
            style: theme.textTheme.bodyText1!.copyWith(
              fontSize: theme.textTheme.bodyText1!.fontSize! * 1.2,
            ),
            child: widget.title!,
          ),
          Divider(
            color: widget.dividerColor,
          ),
        ],
        Container(
          height: widget.heigth ?? (widget.itemHeight) * widget.children.length,
          color: widget.color ?? Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in widget.children)
                InkWell(
                  onTap: () {
                    setState(() {
                      values[item] = !_getValue(item);
                      if (widget.onChanged != null) {
                        widget.onChanged!(widget.children.indexOf(item), item);
                      }
                    });
                  },
                  child: Container(
                    height: widget.itemHeight,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(item),
                        ),
                        (_getValue(item))
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank)
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  bool _getValue(String item) {
    return values[item]!;
  }
}
