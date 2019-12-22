import 'ACBrUtil.dart';

const cMilharSin = ['Bilhão', 'Milhão', 'Mil'];
const cMilharPlu = ['Bilhões', 'Milhões', 'Mil'];
const cUnidade = [
  'Um',
  'Dois',
  'Três',
  'Quatro',
  'Cinco',
  'Seis',
  'Sete',
  'Oito',
  'Nove'
];
const cDez = [
  'Dez',
  'Onze',
  'Doze',
  'Treze',
  'Quatorze',
  'Quinze',
  'Dezesseis',
  'Dezessete',
  'Dezoito',
  'Dezenove'
];
const cDezenas = [
  'Vinte',
  'Trinta',
  'Quarenta',
  'Cinquenta',
  'Sessenta',
  'Setenta',
  'Oitenta',
  'Noventa'
];
const cCentenas = [
  'Cem',
  'Cento',
  'Duzentos',
  'Trezentos',
  'Quatrocentos',
  'Quinhentos',
  'Seiscentos',
  'Setecentos',
  'Oitocentos',
  'Novecentos'
];

enum ACBrExtensoFormato { extPadrao, extDolar }

class ACBrExtenso {
  String fsMoeda;
  String fsMoedas;
  String fsCentavos;
  String fsCentavo;
  double fsValor;
  String fsTexto;
  bool fsZeroAEsquerda;
  ACBrExtensoFormato fsFormato;

  ACBrExtenso() {
    fsMoeda = 'Real';
    fsMoedas = 'Reais';
    fsCentavo = 'Centavo';
    fsCentavos = 'Centavos';
    fsValor = 0;
    fsTexto = '';
    fsZeroAEsquerda = true;
    fsFormato = ACBrExtensoFormato.extPadrao;
  }

  dispose() {}

  get valor => fsValor;
  set valor(double x) {
    traduzValor(x);
  }

  extensoAux(String str3) {
/*{ Funcao de auxilio a Extenso. Retorna uma string contendo o extenso
  de Str3. Esta funcao e apenas monta o extenso de uma string de 3
  digitos, (nao acressenta a moeda ou Titulo (Mil, Milhao, etc..))
  Str3 -> String com 3 casas com Valor a transformar em extenso }*/
    int pos1;
    int pos2;
    int pos3;

    String resultado;

    resultado = '';

    pos1 = strToIntDef(copy(str3, 0, 1), 0);
    pos2 = strToIntDef(copy(str3, 1, 1), 0);
    pos3 = strToIntDef(copy(str3, 2, 1), 0);

    if (pos1 > 0) {
      //Se possuir numero na casa da centena processe }
      //  { Se nao possuir numeros a seguir e POS1 for o numero UM entao = "Cem" }
      if ((pos1 == 1) && ((pos2 + pos3) == 0)) pos1 = 0;
      resultado = cCentenas[pos1];
    }

    if (pos2 > 0) {
      //   { Se possuir numero na casa da dezena processe }

      if (resultado != '')
        // { Se ja possui algum Texto adiciona o ' e ' }
        resultado = resultado + ' e ';

      if (pos2 == 1) {
        // Se for na casa dos dez usa vetor de Dezenas }

        resultado = resultado + cDez[pos3]; //   { Dez, Onze, Doze... }
        pos3 = 0;
      } else
        resultado = resultado + cDezenas[pos2 - 2]; // {Vinte, Trinta...}
    }
    if (pos3 > 0) {
      //    {  Se possuir numero na casa da unidade processe }

      if (resultado != '') //  { Se ja possui algum Texto adiciona o ' e ' }
        resultado += ' e ';

      resultado += cUnidade[pos3 - 1];
    }

    return resultado;
  }

  void traduzValor(double Value) {
    int Inteiros;
    int Decimais;
    String StrInteiros;
    List<String> aStrCasas = ['', '', '', ''];
    if (Value == fsValor) return;

    if (Value > 999999999999.99) //then
      throw 'Valor acima do permitido';

    fsValor = roundTo(Value, -2); // { Apenas 2 decimais }
    fsTexto = '';
    Inteiros = fsValor.truncate();
    Decimais = round(frac(fsValor) * 100).truncate();
    StrInteiros = intToStrZero(Inteiros, 12);

    if (Inteiros > 0) {
      //then   { Se tiver inteiros processe }

      //  { Achando a CASAS dos Bilhoes, Milhoes, Mil, e Cem }
      for (var casa = 0; casa <= 3; casa++)
        aStrCasas[casa] = copy(StrInteiros, (casa * 3) + 0, 3);

      for (var casa = 0; casa <= 3; casa++) {
        // to 3 do

        if (strToIntDef(aStrCasas[casa], 0) == 0) // { Casa vazia ? }
          continue;

        if (fsTexto != '')
        //Se ja existe texto, concatena com "," ou "e"}
        if (casa == 3)
          fsTexto += ' e ';
        else
          fsTexto += ', ';

        fsTexto += extensoAux(aStrCasas[casa]);

        if (casa < 3) {
          // then { Se for acima da casa dos Cem pegue um titulo }
          // { Se a CASA tiver valor de UM usa singular, senao usa o plural }
          if (strToIntDef(aStrCasas[casa], 0) == 1)
            fsTexto += ' ' + cMilharSin[casa];
          else
            fsTexto += ' ' + cMilharPlu[casa];
        }

        //{ Se nao possui valores na casa dos MIL ou dos CEM, concatena ' de' }
        if (strToIntDef(aStrCasas[2] + aStrCasas[3], 0) == 0) fsTexto += ' de';
      }
    } else if (fsZeroAEsquerda) fsTexto = 'Zero';

    //{ Se o valor total for UM usa moeda singular, senao no Plurar }
    if (fsTexto != '') if (fsFormato == ACBrExtensoFormato.extDolar) {
      if (Inteiros == 1)
        fsTexto = fsMoeda + ' ' + fsTexto;
      else
        fsTexto = fsMoedas + ' ' + fsTexto;
    } else {
      if (Inteiros == 1)
        fsTexto = fsTexto + ' ' + fsMoeda;
      else
        fsTexto = fsTexto + ' ' + fsMoedas;
    }

    //{ PROCESSANDO OS DECIMAIS }
    if (fsFormato == ACBrExtensoFormato.extDolar) {
      if (fsTexto != '') //{ Se ja possui algum Texto adiciona o ' com ' }
        fsTexto = fsTexto + ' com ';

      fsTexto = fsTexto + intToStrZero(Decimais, 2) + '/100';
    } else if (Decimais > 0) {
      //

      if (fsTexto != '') // { Se ja possui algum Texto adiciona o ' e ' }
        fsTexto = fsTexto + ' e ';

      fsTexto = fsTexto + extensoAux(intToStrZero(Decimais, 3));

      //{ Se o valor total dos decimais for UM usa singular, senao no Plurar }
      if (Decimais == 1)
        fsTexto = fsTexto + ' ' + fsCentavo;
      else
        fsTexto = fsTexto + ' ' + fsCentavos;
    }

    //{Verificando se é na casa de 1 HUM mil}
    if (fsFormato != ACBrExtensoFormato.extDolar) {
      if (fsValor >= 1000.00) if (fsValor < 2000.00)
        fsTexto = 'Hum' + copy(fsTexto, 3, fsTexto.length);
    }
  }

  String valorToTexto(double value,
      {ACBrExtensoFormato formato = ACBrExtensoFormato.extPadrao}) {
    fsFormato = formato;
    valor = value;
    return fsTexto;
  }
}
