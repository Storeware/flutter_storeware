import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:flutter/widgets.dart';
//import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart';

/// [DataViewerHelper] extende funcionalidade para DataViewer / PaginatedGrid
class DataViewerHelper {
  /// [DataViewerHelper.simnaoColumn] Define coluna  S ou N na visualização
  static simnaoColumn(PaginatedGridColumn column) {
    if (column != null) {
      column.builder = (idx, row) {
        /// visualiza switch no grid
        return MaskedSwitchFormField(
            readOnly: true, value: (row[column.name] ?? 'N') == 'S');
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        return MaskedSwitchFormField(
          label: column.label,
          value: (row[column.name] ?? 'N') == 'S',
          onChanged: (x) {
            row[column.name] = x ? 'S' : 'N';
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
        DateTime d = DateTime.tryParse(v);
        if (d == null) return Text('');
        return Text(d.format(mask));
      };
      column.editBuilder = (a, b, c, row) {
        /// define switch para edição
        dynamic v = row[column.name];
        DateTime d = DateTime.tryParse(v) ?? DateTime.now();
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
