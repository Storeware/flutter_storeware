import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:flutter/widgets.dart';
//import 'package:controls_data/odata_client.dart';import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:flutter/widgets.dart';
//import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

DateTime _toDateTime(value, {DateTime def, zone = -3}) {
  if (value is String) {
    int dif = (value.endsWith('Z') ? zone : 0);
    return DateTime.tryParse(value).add(Duration(hours: dif));
  }
  if (value is DateTime) return value;
  return def ?? DateTime.now();
}

/// [DataViewerHelper] extende funcionalidade para DataViewer / PaginatedGrid
///
class DataViewerHelper {
  /// [DataViewerHelper.simnaoColumn] Define coluna  S ou N na visualização

  static _simnaoFn(p) {
    var t = p['t'];
    var v = p['v'];
    var f = p['f'];
    if ((t == null) && (v != null)) {
      if (v is bool) {
        t = true;
        f = false;
      }
      if (v is int) {
        t = 1;
        f = 0;
      }
      if (v is double) {
        t = 1.0;
        f = 0.0;
      }
    }
    t ??= 'S';
    f ??= 'N';
  }

  static simnaoColumn(PaginatedGridColumn column,
      {dynamic trueValue,
      dynamic falseValue,
      Color color,
      Color inactiveTrackColor}) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        DataViewerHelper._simnaoFn(
            {'v': row[column.name], 't': trueValue, 'f': falseValue});
        return MaskedSwitchFormField(
            activeColor: color,
            activeTrackColor: (color != null) ? color.lighten(50) : null,
            inactiveTrackColor: inactiveTrackColor ??
                ((color != null) ? color.lighten(80) : null),
            readOnly: true,
            value: (row[column.name] ?? falseValue) == trueValue);
      };
      column.editBuilder = (a, b, c, row) {
        DataViewerHelper._simnaoFn(
            {'v': row[column.name], 't': trueValue, 'f': falseValue});

        /// define switch para edição
        return MaskedSwitchFormField(
          activeColor: color,
          activeTrackColor: (color != null) ? color.lighten(50) : null,
          inactiveTrackColor: inactiveTrackColor ??
              ((color != null) ? color.lighten(80) : null),
          label: column.label ?? column.name,
          value: (row[column.name] ?? falseValue) == trueValue,
          onChanged: (x) {
            row[column.name] = x ? trueValue : falseValue;
          },
        );
      };
      return column;
    }
  }

  static stringColumn(PaginatedGridColumn column) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        return Text(
          row[column.name] ?? '',
        );
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return MaskedTextField(
          label: column.label,
          initialValue: row[column.name] ?? '',
          onChanged: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  static dateTimeColumn(PaginatedGridColumn column,
      {mask = 'dd/MM/yyyy', DateTime firstDate, DateTime lastDate}) {
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
          initialValue: d,
          onChanged: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  /// [hideColumn] retira a coluna do grid
  static hideColumn(PaginatedGridColumn column) {
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

  static moneyColumn(PaginatedGridColumn column, {int decimais = 2}) {
    if (column != null) {
      column.numeric = true;
      column.builder = (idx, row) {
        double v = (row[column.name] ?? 0.0) + 0.0;
        return Text(v.toStringAsFixed(decimais));
      };
      column.editBuilder = (a, b, c, row) {
        /// define  edição
        return MaskedMoneyFormField(
          label: column.label,
          precision: decimais,
          initialValue: (row[column.name] ?? 0.0),
          onSaved: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  static hideAll(PaginatedGridController ctr) {
    for (var item in ctr.columns) {
      item.visible = false;
    }
  }

  static showOnly(PaginatedGridController ctr, List<String> list) {
    for (var item in ctr.columns)
      if (list.contains(item.name)) item.visible = true;
  }
}

import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

DateTime _toDateTime(value, {DateTime def, zone = -3}) {
  if (value is String) {
    int dif = (value.endsWith('Z') ? zone : 0);
    return DateTime.tryParse(value).add(Duration(hours: dif));
  }
  if (value is DateTime) return value;
  return def ?? DateTime.now();
}

/// [DataViewerHelper] extende funcionalidade para DataViewer / PaginatedGrid
///
class DataViewerHelper {
  /// [DataViewerHelper.simnaoColumn] Define coluna  S ou N na visualização

  static _simnaoFn(p) {
    var t = p['t'];
    var v = p['v'];
    var f = p['f'];
    if ((t == null) && (v != null)) {
      if (v is bool) {
        t = true;
        f = false;
      }
      if (v is int) {
        t = 1;
        f = 0;
      }
      if (v is double) {
        t = 1.0;
        f = 0.0;
      }
    }
    t ??= 'S';
    f ??= 'N';
  }

  static simnaoColumn(PaginatedGridColumn column,
      {dynamic trueValue,
      dynamic falseValue,
      Color color,
      Color inactiveTrackColor}) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        DataViewerHelper._simnaoFn(
            {'v': row[column.name], 't': trueValue, 'f': falseValue});
        return MaskedSwitchFormField(
            activeColor: color,
            activeTrackColor: (color != null) ? color.lighten(50) : null,
            inactiveTrackColor: inactiveTrackColor ??
                ((color != null) ? color.lighten(80) : null),
            readOnly: true,
            value: (row[column.name] ?? falseValue) == trueValue);
      };
      column.editBuilder = (a, b, c, row) {
        DataViewerHelper._simnaoFn(
            {'v': row[column.name], 't': trueValue, 'f': falseValue});

        /// define switch para edição
        return MaskedSwitchFormField(
          activeColor: color,
          activeTrackColor: (color != null) ? color.lighten(50) : null,
          inactiveTrackColor: inactiveTrackColor ??
              ((color != null) ? color.lighten(80) : null),
          label: column.label ?? column.name,
          value: (row[column.name] ?? falseValue) == trueValue,
          onChanged: (x) {
            row[column.name] = x ? trueValue : falseValue;
          },
        );
      };
      return column;
    }
  }

  static stringColumn(PaginatedGridColumn column) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        return Text(
          row[column.name] ?? '',
        );
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return MaskedTextField(
          label: column.label,
          initialValue: row[column.name] ?? '',
          onChanged: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  static dateTimeColumn(PaginatedGridColumn column,
      {mask = 'dd/MM/yyyy', DateTime firstDate, DateTime lastDate}) {
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
          format: mask,
          labelText: column.label,
          initialValue: d,
          onChanged: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  /// [hideColumn] retira a coluna do grid
  static hideColumn(PaginatedGridColumn column) {
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

  static moneyColumn(PaginatedGridColumn column, {int decimais = 2}) {
    if (column != null) {
      column.numeric = true;
      column.builder = (idx, row) {
        double v = (row[column.name] ?? 0.0) + 0.0;
        return Text(v.toStringAsFixed(decimais));
      };
      column.editBuilder = (a, b, c, row) {
        /// define  edição
        return MaskedMoneyFormField(
          label: column.label,
          precision: decimais,
          initialValue: (row[column.name] ?? 0.0),
          onSaved: (x) {
            row[column.name] = x;
          },
        );
      };
      return column;
    }
  }

  static hideAll(PaginatedGridController ctr) {
    for (var item in ctr.columns) {
      item.visible = false;
    }
  }

  static showOnly(PaginatedGridController ctr, List<String> list) {
    for (var item in ctr.columns)
      if (list.contains(item.name)) item.visible = true;
  }
}
