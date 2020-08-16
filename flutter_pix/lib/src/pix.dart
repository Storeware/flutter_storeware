abstract class Pix {
  g(String code, String value) {
    if ((value ?? '').length == 0) return '';
    int len = value.length;
    var slen = len.toString().padLeft(2, '0');
    return '$code$slen$value';
  }

  String toString();
}

const pixGui = 'BR.GOV.BCB.PIX';

class PixMerchantAccount extends Pix {
  String gui;
  String chave;
  String infoAdicionais;

  ///
  String instituicao;
  String tipoConta;
  String agencia;
  String conta;

  /// uso para brcode dinamico
  String url;
  PixBrCode brCode;
  PixMerchantAccount(
    this.brCode, {
    this.gui = pixGui,
    this.chave,
    this.infoAdicionais,
  });
  validar() {
  if (brCode.payloadFormat==PixPayloadFormat.dinamico){
    if (instituicao==null ||  agencia==null || conta==null || tipoConta==null )
      throw 'Dados do recebedor incompletos';
  if (brCode.payloadFormat == PixPayloadFormat.estatico)
    if (chave==null)
      throw 'Nao informou a chave para transacao estatica';  
  }

  }
  @override
  String toString() {
    validar();
    return g('00', gui) +
        g('01', chave.replaceAll('@', ' ').toUpperCase()) +
        g('02', infoAdicionais) +
        g('21', instituicao) +
        g('22', tipoConta) +
        g('23', agencia) +
        g('24', conta) +
        get72();
  }

  get72() {
    if (url == null) return '';
    g('72', g('00', gui) + g('25', url));
  }
}

class PixPsst extends Pix {
  String gui = 'BR.GOV.BCB.BRCODE';
  String version = '1.0.0';
  @override
  toString() => g('00', gui) + g('01', version);
}

class PixUnreservedTemplates extends Pix {
  String gui;
  String url;
  PixUnreservedTemplates({this.gui, this.url});
  @override
  toString() {
    return g('00', gui) + g('25', url);
  }
}

class PixAdditionalDataField extends Pix {
  /// 1.16.10 - uso interno do recebedor para identificar a transacao. Dado para fim de conciliacao.
  String txId;
  final PixPsst psst = PixPsst();

  /// brcode dinamico
  set referenceLabel(x) => txId = x;
  @override
  toString() {
    return g('05', txId) + g('50', psst.toString());
  }
}

enum PixPayloadFormat { estatico, dinamico }

class PixBrCode extends Pix {
  PixPayloadFormat payloadFormat;
  final PixMerchantAccount merchartAccount;
  String merchantCategory;
  String transactionCurrency = '986';
  String countryCode = 'BR';
  String merchantName;
  String merchantCity;
  PixAdditionalDataField additionalDataField = PixAdditionalDataField();
  double transactionAmount;
  final PixUnreservedTemplates unreservedTemplates = PixUnreservedTemplates();
  String crc;
  PixBrCode(
      {@required this.payloadFormat = PixPayloadFormat.estatico,
      this.merchantCategory,
      this.merchantName,
      this.merchantCity,
      this.transactionAmount}) {
    merchartAccount = PixMerchantAccount(this);
  }
  validar() {
    if ((merchartAccount.url ?? '').length > 77)
      throw 'URL possui limite de 77 caracteres';
  }

  getAmout() {
    if (transactionAmount == null) return '';
    return g('54', transactionAmount.toStringAsFixed(2));
  }

  get payloadFmt => ['01', '02'][payloadFormat.index];
  @override
  toString() {
    validar();
    return g('01', payloadFmt) +
        g('26', merchartAccount.toString()) +
        g('52', this.merchantCategory) +
        g('53', this.transactionCurrency) +
        g('58', countryCode) +
        getAmount() +
        g('59', merchantName.toUpperCase()) +
        g('60', this.merchantCity.toUpperCase()) +
        g('62', this.additionalDataField.toString().toUpperCase()) +
        g('80', unreservedTemplates.toString()) +
        g('63', crc.toUpperCase());
  }
}

/// [PixRequest] format o pedido de transacao na URL
// TODO:
class PixRequest {
  final PixBrCode brCode;
  final String urlBase;
  PixRequest(
      {@required this.urlBase = 'https://pix.bcb.gov.br/qr',
      @required this.brCode});
  get base64 => base64Decode(brCode.toString());
  get url => '$urlbase/$base64';
}

///[PixResponse] formata a resposta da transacao
// TODO;
class PixResponse {
  final Map<String, dynamic> response;
  PixResponse({@required this.response});
}
