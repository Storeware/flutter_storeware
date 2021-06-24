import 'ACBrCalcDigito.dart';
import 'string_extensions.dart';

/// Validar [CNPJ]
String validarCNPJ(String fsDocto,
    {bool fsAjustarTamanho = true, fsExibeDigitoCorreto = false}) {
  String dv1, dv2;
  ACBrCalcDigito modulo = ACBrCalcDigito();
  if (fsAjustarTamanho)
    fsDocto = fsDocto
        .replaceAll('.', '')
        .replaceAll('/', '')
        .replaceAll('-', '')
        .padLeft(14, '0');

  if ((fsDocto.length != 14) || (!fsDocto.strIsNumber())) {
    return 'CNPJ deve ter 14 dígitos. (Apenas números)';
  }

  if (fsDocto == '0'.padLeft(14)) // Prevenção contra 00000000000000
  {
    return 'CNPJ inválido.';
  }

  modulo.calculoPadrao();
  modulo.documento = fsDocto.copy(0, 12);
  modulo.calcular();
  dv1 = (modulo.fsDigitoFinal).toString();

  modulo.documento = fsDocto.copy(0, 12) + dv1;
  modulo.calcular();
  dv2 = (modulo.fsDigitoFinal).toString();

  var fsDigitoCalculado = dv1 + dv2;

  if ((dv1 != fsDocto[12]) || (dv2 != fsDocto[13])) {
    var fsMsgErro = 'CNPJ inválido.';
    if (fsExibeDigitoCorreto)
      fsMsgErro = fsMsgErro + '.. Dígito calculado: ' + fsDigitoCalculado;
    return fsMsgErro;
  }
  return '';
}
