import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/paginated_grid.dart';

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
  }
}
