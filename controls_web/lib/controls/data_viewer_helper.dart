// @dart=2.12
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;
import 'package:flutter/services.dart';

DateTime _toDateTime(value, {DateTime? def, zone = -3}) {
  if (value is String) {
    int dif = (value.endsWith('Z') ? zone : 0);
    return DateTime.tryParse(value)!.add(Duration(hours: dif));
  }
  if (value is DateTime) return value;
  return def ?? DateTime.now();
}

/// [DataViewerHelper] extende funcionalidade para DataViewer / PaginatedGrid
///
class DataViewerHelper {
  /// [DataViewerHelper.simnaoColumn] Define coluna  S ou N na visualização
  static double get defaultWidth => 300.0;
  static _simnaoFn(p) {
    var t = p['t'];
    dynamic? v = p['v'];
    var f = p['f'];
    if ((t == null) && (v != null)) {
      if (v is bool) {
        t = true;
        f = false;
        //v ??= false;
      }
      if (v is int) {
        t = 1;
        f = 0;
        //v ??= 0;
      }
      if (v is double) {
        t = 1.0;
        f = 0.0;
        //v ??= 0.0;
      }
    }
    t ??= 'S';
    f ??= 'N';
    v ??= 'N';
    return {'t': t, 'f': f, 'v': v};
  }

  static simnaoColumn(PaginatedGridColumn? column,
      {dynamic trueValue,
      dynamic falseValue,
      Color? color,
      Function(String key, bool value)? onChanged,
      Color? inactiveTrackColor}) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        var r = DataViewerHelper._simnaoFn(
            {'v': row[column.name!], 't': trueValue, 'f': falseValue});

        bool b = (row[column.name!] ?? r['v']) == r['t'];
        return Text(((b) ? 'Sim' : 'Não'),
            style: TextStyle(
              color: (b) ? color : null,
            ));
      };
      column.editBuilder = (a, b, c, row) {
        var r = DataViewerHelper._simnaoFn(
            {'v': row[column.name!], 't': trueValue, 'f': falseValue});

        /// define switch para edição
        return MaskedSwitchFormField(
          activeColor: color,
          activeTrackColor: (color != null) ? color.lighten(50) : Colors.blue,
          inactiveTrackColor: inactiveTrackColor ??
              ((color != null) ? color.lighten(80) : Colors.blue),
          label: column.label ?? column.name!,
          value: (row[column.name!] ?? r['v']) == r['t'],
          onChanged: (x) {
            row[column.name!] = x ? r['t'] : r['f'];
            if (onChanged != null)
              onChanged(column.name!, row[column.name!] ?? r['f']);
          },
        );
      };
      return column;
    }
  }

  static intColumn(PaginatedGridColumn column,
      {Widget? suffix, Widget? prefix, int? maxLength}) {
    return doubleColumn(column,
        decimais: 0, suffix: suffix, prefix: prefix, maxLength: maxLength);
  }

  static doubleColumn(PaginatedGridColumn? column,
      {int decimais = 2,
      Widget? suffix,
      Widget? prefix,
      Alignment? align,
      Function(double)? onChanged,
      int? maxLength}) {
    if (column != null) {
      Widget? Function(int, Map<String, dynamic>)? builder;
      if (column.builder != null) builder = column.builder;
      column.align = align ?? column.align ?? Alignment.centerRight;
      column.builder = (idx, row) {
        if (builder != null) return builder(idx, row) ?? Container();
        dynamic v = row[column.name!];
        String txt = '${v}';
        if (v is double && decimais >= 0) txt = v.toStringAsFixed(decimais);

        txt = txt.replaceAll('.', ',');
        return Text(
          txt,
        );
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return Container(
            width: column.width ?? defaultWidth,
            child: TextFormField(
              //label: column.label,
              initialValue: '${row[column.name] ?? ''}'.replaceAll('.', ','),
              keyboardType: (decimais <= 0)
                  ? TextInputType.number
                  : TextInputType.numberWithOptions(decimal: decimais > 0),
              inputFormatters: <TextInputFormatter>[
                if (decimais == 0) FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: maxLength ?? column.maxLength,
              decoration: InputDecoration(
                  labelText: (column.editInfo != null)
                      ? (column.editInfo ?? '')
                          .replaceAll('{label}', column.label ?? '')
                      : column.label ?? column.name!,
                  suffix: suffix,
                  prefix: prefix,
                  helperText: column.tooltip ?? ''

                  //    ? (widget.sample != null)
                  //        ? 'Ex: ${widget.sample}'20
                  //        : null
                  //    : null,
                  //hintStyle: theme.inputDecorationTheme.hintStyle,
                  ),
              onChanged: (x) {
                row[column.name!] =
                    double.tryParse(x.replaceAll(',', '.')) ?? 0;
                if (onChanged != null) onChanged(row[column.name!] ?? 0);
              },
            ));
      };
      return column;
    }
  }

  static stringColumn(PaginatedGridColumn? column) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        return Text(
          row[column.name!] ?? '',
        );
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return Container(
            width: column.width ?? defaultWidth,
            child: MaskedTextField(
              label: column.label,
              initialValue: row[column.name!] ?? '',
              onChanged: (x) {
                row[column.name!] = x;
              },
            ));
      };
      return column;
    }
  }

  static dateTimeColumn(PaginatedGridColumn? column,
      {mask = 'dd/MM/yyyy', DateTime? firstDate, DateTime? lastDate}) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        dynamic v = row[column.name];
        if (v == null) return Text('');
        DateTime d = _toDateTime(v); //DateTime.tryParse(v);
        if (d == null) return Text('');
        return Text(d.format(mask));
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        dynamic v = row[column.name];
        DateTime d = _toDateTime(v);
        return MaskedDatePicker(
          firstDate: firstDate,
          lastDate: lastDate,
          readOnly: column.readOnly,
          format: mask,
          labelText: column.label,
          autofocus: column.autofocus,
          initialValue: d,
          onChanged: (x) {
            row[column.name!] = x;
          },
        );
      };
      return column;
    }
  }

  /// [hideColumn] retira a coluna do grid
  static hideColumn(PaginatedGridColumn? column) {
    if (column != null) {
      /// é uma coluna chave
      column.isPrimaryKey = true;

      /// esconde a coluna no grid
      column.visible = false;

      /// retira a coluna da edição
      column.isVirtual = true;
    }
    return column;
  }

  static text(PaginatedGridColumn? column,
      {int decimais = 2, double? width, Color? color}) {
    if (column != null) {
      column.editBuilder = (a, b, c, row) {
        return Container(
          width: width ?? column.width ?? defaultWidth,
          color: color,
          child: MaskedTextField(
            label: column.label,
            initialValue: (row[column.name!] ?? ''),
            onSaved: (x) {
              row[column.name!] = x;
            },
          ),
        );
      };
    }
    return column;
  }

  static moneyColumn(PaginatedGridColumn? column,
      {int decimais = 2, double? width, Color? color}) {
    if (column != null) {
      column.align = Alignment.centerRight;
      column.builder = (idx, row) {
        double v = (row[column.name] ?? 0.0) + 0.0;
        return Text(v.toStringAsFixed(decimais));
      };
      column.editBuilder = (a, b, c, row) {
        /// define  edição
        return Container(
          color: color,
          width: width ?? column.width ?? defaultWidth,
          child: MaskedMoneyFormField(
            label: column.label,
            precision: decimais,
            initialValue: (row[column.name] ?? 0.0) + 0.0,
            onSaved: (x) {
              row[column.name!] = x;
            },
          ),
        );
      };
      return column;
    }
  }

  static hideAll(ctr) {
    for (var item in ctr.columns) {
      item.visible = false;
    }
  }

  static showOnly(ctr, List<String> list) {
    for (var item in ctr.columns)
      if (list.contains(item.name!)) item.visible = true;
  }
}
