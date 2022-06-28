library services;

/// [intRange retorno uma lista com faixa de valores integer]
List<int> intRange(int start, int end, {int skip = 1}) {
  return [for (var i = start; i < end; i += skip) i];
}

/// [intRangeStream] gera um stream com faixa integer de valires
Stream<int> intRangeStream(int start, int end, {int skip = 1}) async* {
  for (var i = start; i < end; i += skip) {
    yield i;
  }
}
