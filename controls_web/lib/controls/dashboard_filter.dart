import 'package:flutter/material.dart';

class DashboardFilter extends StatefulWidget {
  const DashboardFilter({
    Key? key,
    this.width = 250,
    this.height = 150,
    this.elevation = 10,
    this.color = Colors.transparent,
    this.title,
    this.filter,
    this.filterIndex = 0,
    this.onFilterChanged,
    this.child,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? elevation;
  final Color? color;
  final Widget? title;
  final List<String>? filter;
  final int? filterIndex;
  final ValueChanged<int>? onFilterChanged;
  final Widget? child;
  @override
  _DashboardChartsState createState() => _DashboardChartsState();
}

class _DashboardChartsState extends State<DashboardFilter> {
  late int _filterIndex;
  @override
  void initState() {
    super.initState();
    _filterIndex = widget.filterIndex!;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: widget.color,
      elevation: widget.elevation,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DefaultTextStyle(
                  style: theme.textTheme.bodyText1!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  child: SizedBox(
                    height: kMinInteractiveDimension,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.title != null) widget.title!,
                        if (widget.filter != null)
                          DropdownButton<String>(
                            value: widget.filter![_filterIndex],
                            items: widget.filter!.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(value,
                                        style: theme.textTheme.labelMedium),
                                  ));
                            }).toList(),
                            isDense: true,
                            underline: Container(),
                            onChanged: (String? value) {
                              if (value != null) {
                                var index = widget.filter!.indexOf(value);
                                if (widget.onFilterChanged != null) {
                                  widget.onFilterChanged!(index);
                                }
                                setState(() {
                                  _filterIndex = index;
                                });
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: widget.height! - kMinInteractiveDimension - 8,
                width: widget.width,
                //        child: _BarChart(data: widget.data),
                child: widget.child ?? Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
