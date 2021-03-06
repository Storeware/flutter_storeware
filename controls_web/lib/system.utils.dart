library services;

List<int> intRange(int start, int end, {int skip = 1}) {
  return [for (var i = start; i < end; i += skip) i];
}

Stream<int> intRangeStream(int start, int end, {int skip = 1}) async* {
  for (var i = start; i < end; i += skip) {
    yield i;
  }
}
