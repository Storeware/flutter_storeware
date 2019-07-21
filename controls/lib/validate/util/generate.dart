import 'dart:math';

List<int> randomizer(int size) {
  List<int> random = new List<int>();
  for (var i = 0; i < size; i++) {
    random.add(new Random().nextInt(9));
  }
  return random;
}