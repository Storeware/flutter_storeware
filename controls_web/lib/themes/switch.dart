import 'package:flutter/material.dart';
import 'themes.dart';

Color getOpositeThemeColor(context) => DynamicTheme.of(context)!.backColor;
Color getThemeColor(context) => DynamicTheme.of(context)!.color;

void showThemeChooser(context) {
  showDialog<void>(
      context: context,
      builder: (context) {
        return BrightnessSwitcherDialog(
          onSelectedTheme: (brightness) {
            DynamicTheme.of(context)!.setBrightness(brightness);
          },
        );
      });
}

class BrightnessSwitcherDialog extends StatelessWidget {
  const BrightnessSwitcherDialog({Key? key, this.onSelectedTheme})
      : super(key: key);

  final ValueChanged<Brightness>? onSelectedTheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Vamos escolher um tema'),
      children: <Widget>[
        RadioListTile<Brightness>(
          value: Brightness.light,
          groupValue: Theme.of(context).brightness,
          onChanged: (Brightness? value) {
            onSelectedTheme!(Brightness.light);
          },
          title: const Text('Claro'),
        ),
        RadioListTile<Brightness>(
          value: Brightness.dark,
          groupValue: Theme.of(context).brightness,
          onChanged: (Brightness? value) {
            onSelectedTheme!(Brightness.dark);
          },
          title: const Text('Escuro'),
        ),
      ],
    );
  }
}
