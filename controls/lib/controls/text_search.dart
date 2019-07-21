///import 'dart:convert';

class TextSearch {
  static String retirarAcentos(String base) {
    var ca = "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝŔÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŕ";
    var comAcento = ca.codeUnits;
    var semAcento =
        ("AAAAAAACEEEEIIIIDNOOOOOOUUUUYRsBaaaaaaaceeeeiiiionoooooouuuuybyr")
            .codeUnits;
    var novaStr = "";
    var bTrocar = false;
    var str = base.codeUnits;

    for (var i = 0; i < str.length; i++) {
      ///if (str[i]>255) continue;
      bTrocar = false;
      for (var a = 0; a < comAcento.length; a++) {
        if (str[i] == comAcento[a]) {
          novaStr += new String.fromCharCode(semAcento[a]);
          bTrocar = true;
          break;
        }
      }
      if (bTrocar == false) {
        novaStr += new String.fromCharCode(str[i]);
      }
    }
    return novaStr;
  }

  static String clear(String text) {
    if (text.replaceAll('[0-9]', '') == ""){
        return text; // se for tudo numero não pode
    }
    return TextSearch.retirarAcentos(text);
  }

  static String filtered(String text, List<String> ignore) {
    String ignorar;
    var p = ['de', 'para', 'do', 'ate', 'da'];
    var tx = TextSearch.clear(text);
    if (tx.length > 0) {
      for (var element in p) {
        if ((ignorar == null) && (element == tx)) ignorar = tx;
      }

    }
    if (ignorar == null) {
      return tx;
    } else {
      return "";
    }

  }

  static bool lowerAll(str) {
    var x = ',de,para,ate,a,e,ou,das,dos,ao,aos,o,em,';
    return TextSearch.retirarAcentos(',' + x + ',').indexOf(str) >= 0;
  }

  static String lowerAcentuados(str) {
    var comAcento = "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝŔÞß";
    var semAcento = "àáâãaaaçeéêeiíîidnoóôõoouúûuyrsb";
    var novastr = "";
    for (int i = 0; i < str.length; i++) {
      var troca = false;
      for (var a = 0; a < comAcento.length; a++) {
        if (str.substr(i, 1) == comAcento.substring(a, 1)) {
          novastr += semAcento.substring(a, 1);
          troca = true;
          break;
        }
      }
      if (troca == false) {
        novastr += str.substr(i, 1);
      }
    }
    return novastr;
  }

  static upperCapital(x) {
    if (!x) return '';
    var names = [], rt = '';
    names = x.split(' ');
    if (names.length == 0) rt = x;
    /// se já existir uma minuscula, nao fazer nada
    var achei = false;
    for (var i = 0; i < x.length; i++) {
      var element = x[i];
      var l = element.toLowerCase(), u = element.toUpperCase();
      if (l != u && l == element) {
        achei = true;
      }
    }

    if (achei) return x;

    /// trocar cada palavra
    for (var element in names) {
      if (lowerAll(element)) {
        rt += element.toLowerCase() + ' ';
      } else if (element.length > 1) {
        String c1 = element.substring(0, 1);
        String c2 = lowerAcentuados(element.substring(1, 255));
        if (c1.toLowerCase() != c1 && c2.toLowerCase() != c2) {
          rt += c1.toUpperCase() + c2.toLowerCase() + ' ';
        } else {
          rt += element + ' ';
        }

      }
    }

    //console.log(rt);
    return rt.trim();
  }

  static bool acepted(String texto) {
    return ((texto != null) && (texto.length > 1));
  }

  decode(text) {
    dynamic r = {};
    List<String> splitted = retirarAcentos(text).split(" ");
    splitted.forEach((element) {
      String tmp = element.toLowerCase();
      String s = TextSearch.toFieldNameFormat(filtered(tmp, []));
      if (s != '' && acepted(s)) {
        r[s] = true;
      }
    });
    return r;
  }

  static encodeWhere(w, String path, String text) {
    var query=w;
    List<String> splitData = text.split(" ");
    //print(splitData);
    splitData.forEach((element) {
      var tmp = clear(element.toLowerCase());
      var s = TextSearch.toFieldNameFormat(filtered(tmp, []));
      if (s != '' && acepted(s)) {
        var v = path + s;
        //print(v);
        query = query.where(v, isEqualTo: true);
        return w;
      }
    });
    return query;
  }

  static String toFieldNameFormat(String nomeField) {
    if (nomeField==null) nomeField='';
    return retirarAcentos(nomeField).replaceAll('/', '-').replaceAll('.','_');
  }
}
