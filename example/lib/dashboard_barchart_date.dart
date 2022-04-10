import 'package:flutter/material.dart';
import 'package:flutter_storeware/chart.dart';

class DashboardBarChartDateData {
  final DateTime date;
  final double value;
  final String? label;
  DashboardBarChartDateData(
      {this.label, required this.date, required this.value});
}

class DashboardDateBarChart extends StatefulWidget {
  const DashboardDateBarChart({
    Key? key,
    this.width,
    this.height,
    this.elevation = 0,
    this.color,
    this.title,
    this.filter,
    this.filterIndex = 0,
    this.onFilterChanged,
//    this.onGetLabel,
    required this.data,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? elevation;
  final Color? color;
  final Widget? title;
  final List<String>? filter;
  final int? filterIndex;
  final ValueChanged<int>? onFilterChanged;
  final List<DashboardBarChartDateData> data;
  @override
  _DashboardChartsState createState() => _DashboardChartsState();
}

class _DashboardChartsState extends State<DashboardDateBarChart> {
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
                                child: Text(value,
                                    style: theme.textTheme.labelMedium),
                              );
                            }).toList(),
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
                child: DashHorizontalBarChart(
                  DashHorizontalBarChart.createSerie(
                    id: 'dashboard',
                    data: [
                      for (var item in widget.data)
                        ChartPair(_getLabel(item), item.value),
                    ],
                  ),
                  showSeriesNames: false,
                  vertical: true,
                  showAxisLine: false,
                  showValues: true,
                  showDomainAxis: true,
                  animate: false,
                  onSelected: (p) {
                    return p.value;
                  },
                  barRadius: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLabel(DashboardBarChartDateData item) {
    var s = item.label;
    s ??= item.date.day.toString().padLeft(2, '0');
    print(s);
    return s;
  }
}
