import "string_extensions.dart";

enum ACBrCalcDigFormula { frModulo11, frModulo10, frModulo10PIS }

class ACBrCalcDigito {
  int fsMultIni = 2;
  int fsMultFim = 9;
  int fsMultAtu = 0;
  ACBrCalcDigFormula fsFormulaDigito = ACBrCalcDigFormula.frModulo11;
  String fsDocto = '';
  int fsDigitoFinal = 0;
  int fsSomaDigitos = 0;
  int fsModuloFinal = 2;
  ACBrCalcDigito() {
    fsMultAtu = 0;
  }
  String get documento => fsDocto;
  set documento(String x) {
    fsDocto = x;
  }

  int get multiplicadorInicial => fsMultIni;
  set multiplicadorInicial(int x) {
    fsMultIni = x;
  }

  int get multiplicadorFinal => fsMultFim;
  set multiplicadorFinal(int x) {
    fsMultFim = x;
  }

  calculoPadrao() {
    fsMultIni = 2;
    fsMultFim = 9;
    fsMultAtu = 0;
    fsFormulaDigito = ACBrCalcDigFormula.frModulo11;
  }

  calcular() {
    int N, Base, Tamanho, ValorCalc;
    String ValorCalcSTR;

    fsSomaDigitos = 0;
    fsDigitoFinal = 0;
    fsModuloFinal = 0;

    if ((fsMultAtu >= fsMultIni) && (fsMultAtu <= fsMultFim))
      Base = fsMultAtu;
    else
      Base = fsMultIni;
    Tamanho = fsDocto.length;

    //{ Calculando a Soma dos digitos de traz para diante, multiplicadas por BASE }
    for (var A = 0; A < Tamanho; A++) {
      N = (fsDocto[Tamanho - A - 1]).toIntDef(0);
      ValorCalc = (N * Base);

      if ((fsFormulaDigito == ACBrCalcDigFormula.frModulo10) &&
          (ValorCalc > 9)) {
        ValorCalcSTR = ValorCalc.toString();
        ValorCalc = (ValorCalcSTR[1]).toInt() + (ValorCalcSTR[2]).toInt();
      }

      fsSomaDigitos = fsSomaDigitos + ValorCalc;

      if (fsMultIni > fsMultFim) {
        Base--;
        if (Base < fsMultFim) Base = fsMultIni;
      } else {
        Base++;
        if (Base > fsMultFim) Base = fsMultIni;
      }
    }

    switch (fsFormulaDigito) {
      case ACBrCalcDigFormula.frModulo11:
        {
          fsModuloFinal = fsSomaDigitos % 11;

          if (fsModuloFinal < 2)
            fsDigitoFinal = 0;
          else
            fsDigitoFinal = 11 - fsModuloFinal;
          break;
        }

      case ACBrCalcDigFormula.frModulo10PIS:
        {
          fsModuloFinal = (fsSomaDigitos % 11);
          fsDigitoFinal = 11 - fsModuloFinal;

          if (fsDigitoFinal >= 10) fsDigitoFinal = 0;
          break;
        }

      case ACBrCalcDigFormula.frModulo10:
        {
          fsModuloFinal = (fsSomaDigitos % 10);
          fsDigitoFinal = 10 - fsModuloFinal;

          if (fsDigitoFinal >= 10) fsDigitoFinal = 0;
          break;
        }
      default:
        {
          throw 'ACBrCalcDigFormula inválido';
        }
    }
  }
}

class ACBrValidador {}
