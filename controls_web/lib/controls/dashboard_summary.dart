import 'package:flutter/material.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({
    Key? key,
    this.title,
    this.value,
    this.percent,
    this.message,
    this.actions,
    this.icon,
    this.color,
    this.elevation = 10,
    this.height = 70,
    this.width = 150,
    this.onPressed,
    this.child,
  }) : super(key: key);
  final Widget? title;
  final Widget? value;
  final Widget? percent;
  final Widget? message;
  final List<Widget>? actions;
  final Widget? icon;
  final Color? color;
  final double? elevation;
  final double? height;
  final double? width;
  final Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return (onPressed == null)
        ? _builder(theme)
        : InkWell(
            onTap: onPressed,
            child: _builder(theme),
          );
  }

  Card _builder(ThemeData theme) {
    return Card(
      color: color,
      elevation: elevation,
      child: SizedBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Row(children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8.0)],
                if (title != null)
                  DefaultTextStyle(
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      child: title!),
                const Spacer(),
                if (actions != null) ...actions!,
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (value != null)
                    DefaultTextStyle(
                      style: theme.textTheme.bodyText1!.copyWith(
                          color: theme.colorScheme.onSurface, fontSize: 18),
                      child: value!,
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (percent != null)
                        DefaultTextStyle(
                          style: theme.textTheme.bodyText2!.copyWith(
                            //color: theme.colorScheme.onSurface,
                            fontSize: 10,
                          ),
                          child: percent!,
                        ),
                      if (message != null)
                        DefaultTextStyle(
                          style: theme.textTheme.bodyText2!.copyWith(
                            //color: theme.colorScheme.onSurface,
                            fontSize: 10,
                          ),
                          child: message!,
                        ),
                    ],
                  )
                ],
              ),
            ),
            if (child != null) Expanded(child: child!),
          ],
        ),
        height: height,
        width: width,
      ),
    );
  }
}
