import './util/generate.dart';

String gerarCNPJ({bool formatted = false}) {
  List<int> n = randomizer(12);
  n
    ..add(gerarDigitoVerificador(n))
    ..add(gerarDigitoVerificador(n));
  return formatted ? formatar(n) : n.join();
}

int gerarDigitoVerificador(List<int> digits) {
  int baseNumber = 0;
  List<int> firstBlock = digits.getRange(0, digits.length - 8).toList();
  List<int> secondBlock = digits.getRange(digits.length - 8, digits.length).toList();
  for (var i = 0; i < firstBlock.length; i++) {
    baseNumber += firstBlock[i] * ((firstBlock.length + 1) - i);
  }
  for (var i = 0; i < secondBlock.length; i++) {
    baseNumber += secondBlock[i] * ((secondBlock.length + 1) - i);
  }
  int verificationBase = baseNumber % 11;
  return verificationBase < 2 ? 0 : 11 - verificationBase;
}

bool validarCNPJ(String cnpj) {
  List<int> sanitizedCNPJ = cnpj
    .replaceAll(new RegExp(r'\.|-|\/'), '')
    .split('')
    .map((String digit) => int.parse(digit))
    .toList();
  return
    sanitizedCNPJ[12] == gerarDigitoVerificador(sanitizedCNPJ.getRange(0, 12).toList()) &&
    sanitizedCNPJ[13] == gerarDigitoVerificador(sanitizedCNPJ.getRange(0, 13).toList());
}

String formatar(List<int> n) =>
  '${n[0]}${n[1]}.${n[2]}${n[3]}${n[4]}.${n[5]}${n[6]}${n[7]}/${n[8]}${n[9]}${n[10]}${n[11]}-${n[11]}${n[12]}';
