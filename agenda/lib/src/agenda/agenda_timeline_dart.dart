// @dart=2.12

import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';

import 'agenda_const.dart';
import 'agenda_controller.dart';

import 'agenda_notifier.dart';
import 'package:controls_extensions/extensions.dart';

class VerticalTimeline extends StatelessWidget {
  final String? title;
  final double? width;
  final double start;
  final double end;
  final DateTime? date;
  final Color? color;
  final Function()? onPrior;
  final Function()? onNext;
  final Function()? onList;
  final DefaultSourceList? list;
  const VerticalTimeline({
    Key? key,
    this.width,
    this.title,
    this.color,
    required this.start,
    required this.end,
    required this.date,
    this.onPrior,
    this.onNext,
    this.onList,
    this.list,
  }) : super(key: key);

//class _VerticalTimeWidgetState extends State<VerticalTimeline> {
//  String _title;
  get widget => this;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    final _color = widget.color ?? theme.primaryColor.withAlpha(50);
    final _title = widget.title ?? ''; //?? formated.format(widget.date);
    var controller = DefaultAgenda.of(context)!.controller!;

    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Size sizes = renderBox?.size ?? size;

    controller.cardHeigth = calcHeight(sizes, widget.start, widget.end);
    ResponsiveInfo responsive = ResponsiveInfo(context);
    var _width =
        width ?? (responsive.isMobile) ? kTimePanelWidthSmall : kTimePanelWidth;
    var _titleHeight = (responsive.isMobile) ? kTitleHeightSmall : kTitleHeight;
    return Card(
        color: _color,
        elevation: 0,
        margin: EdgeInsets.all(responsive.isMobile ? 1 : 4),
        child: SizedBox(
          width: _width,
          child: Stack(children: [
            Positioned(
              top: 0,
              child: SizedBox(
                height: _titleHeight,
                width: _width,
                child: Stack(
                  children: [
                    /// botao prior da data na timeline
                    if (!responsive.isMobile)
                      Positioned(
                        left: -1,
                        top: 0,
                        child: Container(
                          color: _color,
                          //color: responsive.theme.primaryColor,
                          height: _titleHeight,
                          alignment: Alignment.center,
                          width: 15,
                          child: InkWell(
                            child: const Icon(Icons.arrow_left, size: 15),
                            onTap: () {
                              if (widget.onPrior != null) widget.onPrior();
                            },
                          ),
                        ),
                      ),

                    /// botao next da data na timeline
                    if (!responsive.isMobile)
                      Positioned(
                        right: -1,
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          color: _color,
                          //color: responsive.theme.primaryColor,
                          height: _titleHeight,
                          width: 15,
                          child: InkWell(
                            child: const Icon(Icons.arrow_right, size: 15),
                            onTap: () {
                              if (widget.onNext != null) widget.onNext();
                            },
                          ),
                        ),
                      ),

                    /// titulo da timeline
                    Positioned(
                      left: responsive.isMobile ? 1 : 12,
                      right: responsive.isMobile ? 1 : 12,
                      child: InkWell(
                        child: AgendaPanelTitle(
                          alignment: Alignment.center,
                          color: _color,
                          title: _title,
                          //resource: null,
                          style: const TextStyle(fontSize: kTimeFontSize),
                          width: _width,
                          height: _titleHeight,
                        ),
                        onDoubleTap: () {
                          controller.dataChange(DateTime.now());
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: controller.data!,
                            firstDate: DateTime(controller.data!.year - 1, 1),
                            lastDate: DateTime(controller.data!.year + 1, 12),
                          ).then((dt) {
                            controller.dataChange(dt);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ), //),

            /// grid da timeline
            for (var i = controller.iStart; i <= controller.iEnd; i++)
              Positioned(
                top: controller.calcTop(i + 0.0),
                child: InkWell(
                  child: Container(
                    height: controller.cardHeigth,
                    width: _width,
                    decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(i * 10),
                        border: const Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(responsive.isMobile ? '$i' : '$i:00',
                            style: const TextStyle(fontSize: kTimeFontSize)),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  onTap: () {
                    controller.list(list, i);
                  },
                ),
              ), //)
          ]),
        ));
  }

  static calcHeight(Size sizes, double start, double end) {
    return sizes.height / ((end - start + 1) ~/ 1) - 4;
  }

  double? calcularTop(
      sizes, double height, DateTime date, double start, double end, row) {
    return calcHeight(sizes, start, end) * row;
  }
}

class AgendaPanelTitle extends StatelessWidget {
  final String? title;
  final Color? color;
  final Alignment alignment;
  final double? width;
  final double? height;
  final TextStyle? style;
  final Function()? onList;
  final List<Widget>? actions;
  //final String resource;
  final int? count;
  const AgendaPanelTitle({
    Key? key,
    this.title,
    this.color,
    this.alignment = Alignment.centerLeft,
    this.width,
    this.style,
    this.count,
    this.onList,
    this.actions,
    this.height,
    //@required this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // AgendaController controller = DefaultAgenda.of(context).controller;
    return DefaultTextStyle(
        style: theme.primaryTextTheme.bodyText1!,
        child: InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: height ?? kTitleHeight,
              width: width,
              color: color ?? theme.primaryColor,
              child: (count != null)
                  ? Row(
                      children: [
                        Expanded(child: buildItem()),
                        if (actions != null) ...actions!,
                        if (count! > 0)
                          CircleAvatar(
                            radius: 10,
                            child: Text('$count',
                                style: const TextStyle(fontSize: 10)),
                          ),
                      ],
                    )
                  : buildItem(),
            ),
            onTap: () {
              if ((count ?? 0) > 0) if (onList != null) onList!();
            }));
  }

  Align buildItem() {
    return Align(
      alignment: alignment,
      child: Text(
        title ?? '',
        style: style,
      ),
    );
  }
}

lighter(Color c) {
  return c.lighten(40);
}

darken(Color c) {
  return c.darken(40);
}

Color? genWeekDayColor(DateTime data) {
  var cores = [
    Colors.lightBlueAccent[100],
    pastelColors[5],
    pastelColors[0],
    //Colors.orange[100],
    //Colors.red[200],
    pastelColors[7],
    Colors.cyan[200],
    Colors.green[200],
    pastelColors[9],
    //Colors.amber[200],
  ];
  //cores = pastelColors;
  var wd = data.weekday - 1;
  return (cores[wd % 2]);
}
