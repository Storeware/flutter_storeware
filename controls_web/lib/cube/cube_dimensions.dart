import 'package:flutter/material.dart';

/// [CubeViewType]
/// all-> pode ser usada em todos (dimensão ou valores)
/// row-> em Linhas
/// column -> em colunas
/// both -> row ou colunas
/// value -> somente totalizadores
/// aggr -> valor usando em sumarios (uso interno)
/// data -> coluna dinamica (uso interno)
enum CubeViewType { none, row, column, both, value, aggr, data, all }

enum CubeViewAggrType { none, sum, min, max, avg, virtual }

/// [CubeDimension] mantem o atributo da linha, coluna ou valores;
class CubeDimension {
  String? label;
  String? name;
  String? dataName;
  CubeViewType? viewType;
  CubeViewAggrType? aggrType;
  double? width;
  String? aggrName;
  Widget Function(dynamic)? builder;
  double partValue = 0;
  String? partKeyValue;
  String? curKeyValue;
  double totalValue = 0;
  String? Function(dynamic)? onGetValue;
  int? tag;
  CubeDimension({
    this.label,
    this.name,
    this.width = 120,
    this.builder,
    this.onGetValue,
    this.viewType,
    this.aggrType = CubeViewAggrType.none,
  }) {
    if (viewType == null) {
      viewType = CubeViewType.both;
      if ([
        CubeViewAggrType.sum,
        CubeViewAggrType.min,
        CubeViewAggrType.max,
        CubeViewAggrType.avg
      ].contains(aggrType)) {
        viewType = CubeViewType.all;
      }
    }
  }

  /// usado nas colunas para indicar o valor de referencia
  dynamic data;
}
