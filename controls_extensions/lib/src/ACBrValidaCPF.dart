import 'ACBrCalcDigito.dart';
import 'string_extensions.dart';

String validarCPF(String fsDocto,
    {bool fsAjustarTamanho = true, fsExibeDigitoCorreto = false}) {
  String dv1, dv2;
  ACBrCalcDigito modulo = ACBrCalcDigito();
  if (fsAjustarTamanho)
    fsDocto = fsDocto.replaceAll('.', '').replaceAll('-', '').padLeft(11, '0');

  if ((fsDocto.length != 11) || (!fsDocto.strIsNumber())) {
    return 'CPF deve ter 11 dígitos. (Apenas números)';
  }

  if ('11111111111.22222222222.33333333333.44444444444.55555555555.66666666666.77777777777.88888888888.99999999999.00000000000'
      .contains(fsDocto)) {
    return 'CPF inválido !';
  }

  modulo.fsMultIni = 2;
  modulo.fsMultFim = 11;
  modulo.fsFormulaDigito = ACBrCalcDigFormula.frModulo11;
  modulo.documento = fsDocto.copy(0, 9);
  modulo.calcular();
  dv1 = (modulo.fsDigitoFinal).toString();

  modulo.documento = fsDocto.copy(0, 9) + dv1;
  modulo.calcular();
  dv2 = (modulo.fsDigitoFinal).toString();

  var fsDigitoCalculado = dv1 + dv2;

  if ((dv1 != fsDocto[9]) || (dv2 != fsDocto[10])) {
    var fsMsgErro = 'CPF inválido.';

    if (fsExibeDigitoCorreto)
      fsMsgErro = fsMsgErro + '.. Dígito calculado: ' + fsDigitoCalculado;
    return fsMsgErro;
  }
  return '';
}
