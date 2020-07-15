import 'package:controls_web/controls/masked_field.dart';
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
  static simnaoColumn(PaginatedGridColumn column,
      {dynamic trueValue, dynamic falseValue}) {
    trueValue ??= 'S';
    falseValue ??= 'N';
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        return MaskedSwitchFormField(
            readOnly: true,
            value: (row[column.name] ?? falseValue) == trueValue);
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return MaskedSwitchFormField(
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

  static dateTimeColumn(PaginatedGridColumn column, {mask = 'dd/MM/yyyy'}) {
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
