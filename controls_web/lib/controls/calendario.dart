import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';

class Calendario extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime>? datas;
  final String? title;
  final int? days;
  final Color? color;
  final double? elevation;
  final double? width;
  final Function(DateTime)? onDateChanged;

  Calendario({
    Key? key,
    this.initialDate,
    this.onDateChanged,
    this.datas,
    this.days = 34,
    this.firstDate,
    this.lastDate,
    this.title,
    this.color,
    this.elevation = 1,
    this.width = 350,
  }) : super(key: key);

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime? selectedDate;
  @override
  void initState() {
    selectedDate = widget.initialDate.toDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime inicio = widget.firstDate.startOfWeek();
    Size size = MediaQuery.of(context).size;
    double w = size.width * 0.9;
    if (w > widget.width!) w = widget.width!;
    double h1 = (w / 7);
    double h = h1 * 5;
    return Card(
      elevation: widget.elevation,
      child: Column(
        children: [
          if (widget.title != null)
            Text(widget.title!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Container(
              constraints: BoxConstraints(maxHeight: 40, maxWidth: w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < 7; i++)
                    Center(
                        child: Text(
                            [
                              'Seg',
                              'Ter',
                              'Qua',
                              'Qui',
                              'Sex',
                              'Sáb',
                              'Dom'
                            ][i],
                            style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              )),
          Container(
            constraints: BoxConstraints(maxHeight: h, maxWidth: w),
            color: widget.color,
            child: GridView.count(
              primary: false,
              crossAxisCount: 7,
              children: [
                for (DateTime d in inicio.rangeTo(widget.lastDate!))
                  createDay(d)
              ],
            ),
          ),
        ],
      ),
    );
  }

  int index = 0;

  createDay(DateTime d) {
    int c = d.compareTo(widget.initialDate.toDate());

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: (c >= 0)
          ? InkWell(
              child: Container(
                  decoration: BoxDecoration(
                    color: genWeekDayColor(d).withAlpha(50),
                    border: (sameSelected(d))
                        ? Border.all(width: 1, color: Colors.black)
                        : Border.all(width: 0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(d.format('dd')),
                      if ((d.day == 1) || ((index++) == 0))
                        Text(d.format('MMM')),
                    ],
                  )),
              onTap: () {
                setState(() {
                  selectedDate = d;
                  if (widget.onDateChanged != null) widget.onDateChanged!(d);
                });
              },
            )
          : Container(),
    );
  }

  bool sameSelected(d) {
    if (d == null || selectedDate == null) return false;
    return d.compareTo(selectedDate) == 0;
  }
}

Color genWeekDayColor(DateTime data) {
  var wd = data.weekday - 1;
  return genNWeekDayColor(wd);
}

Color genNWeekDayColor(int wd) {
  var cores = [
    Colors.lightBlue,
    Colors.orange,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.grey.withAlpha(100),
  ];
  int n = (wd % 7);
  return (cores[n]);
}

extension DateTimeEx on DateTime {
  dayOfYear(DateTime data) {
    return data.difference(DateTime(data.year, 1, 1)).inDays;
  }

  List<DateTime> rangeTo(DateTime ate) {
    DateTime de = DateTime(this.year, this.month, this.day);
    List<DateTime> r = [];
    while (de.compareTo(ate) <= 0) {
      r.add(DateTime(de.year, de.month, de.day));
      de = de.add(Duration(days: 1));
    }
    return r;
  }

  int compareDay(DateTime d) {
    return (DateTime(d.year, d.month, d.day)
        .compareTo(DateTime(this.year, this.month, this.day)));
  }
}

class CalendarioHoras extends StatefulWidget {
  final double? width;
  final List<String>? horas;
  final String? value;
  final Function(String)? onChanged;
  final String? title;
  final double? elevation;
  CalendarioHoras({
    Key? key,
    this.width = 350,
    this.horas,
    this.onChanged,
    this.value,
    this.title,
    this.elevation = 1,
  }) : super(key: key);

  @override
  _CalendarioHorasState createState() => _CalendarioHorasState();
}

class _CalendarioHorasState extends State<CalendarioHoras> {
  String? selected;
  @override
  void initState() {
    super.initState();
    selected = widget.value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double w = widget.width! / 7;
    int index = 0;
    return Card(
      elevation: widget.elevation,
      child: Container(
        width: widget.width,
        child: Column(
          children: [
            if (widget.title != null)
              Text(widget.title!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Wrap(spacing: 0, children: [
              for (String item in widget.horas!)
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: InkWell(
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: (item == selected)
                              ? Border.all(width: 1, color: Colors.black)
                              : Border.all(width: 0),
                          color: genNWeekDayColor(index++).withAlpha(50),
                        ),
                        width: w,
                        height: 30,
                        child: Text(item)),
                    onTap: () {
                      setState(() => selected = item);
                      if (widget.onChanged != null) widget.onChanged!(item);
                    },
                  ),
                )
            ]),
          ],
        ),
      ),
    );
  }
}
