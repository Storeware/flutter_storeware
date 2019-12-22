import 'string_extensions.dart';
import 'ACBrValidaUF.dart';

String validarCEP(
  String fsDocto, {
  String fsComplemento = '',
  bool fsAjustarTamanho = true,
}) {
  ;

  if (fsAjustarTamanho) fsDocto = (fsDocto).padLeft(8, '0').trim();

  if (((fsDocto).length != 8) && (!(fsDocto).strIsNumber())) {
    return 'CEP deve ter 8 dígitos. (Apenas números)';
  }

  //{ Passou o UF em Complemento ? Se SIM, verifica o UF }
  fsComplemento = (fsComplemento).trim();
  String fsMsgErro = '';
  if (fsComplemento != '') {
    fsMsgErro = validarUF(fsComplemento);
    if (fsMsgErro != '') return fsMsgErro;
  }

  if (((fsDocto >= '01000000') && (fsDocto <= '19999999')) && // { SP }
      ((fsComplemento == 'SP') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '20000000') && (fsDocto <= '28999999')) && //{ RJ }
      ((fsComplemento == 'RJ') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '29000000') && (fsDocto <= '29999999')) && // { ES }
      ((fsComplemento == 'ES') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '30000000') && (fsDocto <= '39999999')) && //{ MG }
      ((fsComplemento == 'MG') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '40000000') && (fsDocto <= '48999999')) && //{ BA }
      ((fsComplemento == 'BA') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '49000000') && (fsDocto <= '49999999')) && //{ SE }
      ((fsComplemento == 'SE') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '50000000') && (fsDocto <= '56999999')) && //{ PE }
      ((fsComplemento == 'PE') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '57000000') && (fsDocto <= '57999999')) && //{ AL }
      ((fsComplemento == 'AL') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '58000000') && (fsDocto <= '58999999')) && //{ PB }
      ((fsComplemento == 'PB') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '59000000') && (fsDocto <= '59999999')) && //{ RN }
      ((fsComplemento == 'RN') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '60000000') && (fsDocto <= '63999999')) && // { CE }
      ((fsComplemento == 'CE') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '64000000') && (fsDocto <= '64999999')) && //{ PI }
      ((fsComplemento == 'PI') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '65000000') && (fsDocto <= '65999999')) && // { MA }
      ((fsComplemento == 'MA') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '66000000') && (fsDocto <= '68899999')) && // { PA }
      ((fsComplemento == 'PA') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '68900000') && (fsDocto <= '68999999')) && //{ AP }
      ((fsComplemento == 'AP') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '69000000') && (fsDocto <= '69299999')) && //{ AM }
      ((fsComplemento == 'AM') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '69300000') && (fsDocto <= '69399999')) && // { RR }
      ((fsComplemento == 'RR') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '69400000') && (fsDocto <= '69899999')) && //{ AM }
      ((fsComplemento == 'AM') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '69900000') && (fsDocto <= '69999999')) && //{ AC }
      ((fsComplemento == 'AC') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '70000000') && (fsDocto <= '72799999')) && //{ DF }
      ((fsComplemento == 'DF') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '72800000') && (fsDocto <= '72999999')) && //{ GO }
      ((fsComplemento == 'GO') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '73000000') && (fsDocto <= '73699999')) && //{ DF }
      ((fsComplemento == 'DF') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '73700000') && (fsDocto <= '76799999')) && //{ GO }
      ((fsComplemento == 'GO') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '77000000') && (fsDocto <= '77999999')) && //{ TO }
      ((fsComplemento == 'TO') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '78000000') && (fsDocto <= '78899999')) && //{ MT }
      ((fsComplemento == 'MT') || (fsComplemento == ''))) return '';

/* if ((fsDocto >= '78900000') && (fsDocto <= '78999999')) && { RO }
 Faixa antiga foi removida: http://acbr.sourceforge.net/mantis/view.php?id=19 */
  if (((fsDocto >= '76800000') && (fsDocto <= '76999999')) && //{ RO }
      ((fsComplemento == 'RO') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '79000000') && (fsDocto <= '79999999')) && //{ MS }
      ((fsComplemento == 'MS') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '80000000') && (fsDocto <= '87999999')) &&

      ///{ PR }
      ((fsComplemento == 'PR') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '88000000') && (fsDocto <= '89999999')) && //{ SC }
      ((fsComplemento == 'SC') || (fsComplemento == ''))) return '';

  if (((fsDocto >= '90000000') && (fsDocto <= '99999999')) && //{ RS }
      ((fsComplemento == 'RS') || (fsComplemento == ''))) return '';

  if (fsComplemento != '')
    return 'CEP inválido para ' + fsComplemento + ' !';
  else
    return 'CEP inválido !';
}
