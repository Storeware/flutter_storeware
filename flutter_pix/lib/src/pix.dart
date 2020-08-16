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
  PixMerchantAccount({
    this.gui = pixGui,
    this.chave,
    this.infoAdicionais,
  });
  @override
  String toString() {
    return g('00', gui) + g('01', chave) + g('02', infoAdicionais);
  }
}

class PixPsst extends Pix {
  String gui = 'BR.GOV.BCB.BRCODE';
  String version = '1.0.0';
  @override
  toString() => g('00', gui) + g('01', version);
}

class PixAdditionalDataField extends Pix {
  String txId;
  final PixPsst psst = PixPsst();
  @override
  toString() {
    return g('05', txId) + g('50', psst.toString());
  }
}

class PixBrCode extends Pix {
  String payloadFormat = '01';
  final PixMerchantAccount merchartAccount = PixMerchantAccount();
  String merchantCategory;
  String transactionCurrency = '986';
  String countryCode = 'BR';
  String merchantName;
  String merchantCity;
  PixAdditionalDataField additionalDataField = PixAdditionalDataField();
  String crc;
  PixBrCode({
    this.merchantCategory,
    this.merchantName,
    this.merchantCity,
  });
  @override
  toString() {
    return g('01', payloadFormat) +
        g('26', merchartAccount.toString()) +
        g('52', this.merchantCategory) +
        g('53', this.transactionCurrency) +
        g('58', countryCode) +
        g('59', merchantName.toUpperCase()) +
        g('60', this.merchantCity.toUpperCase()) +
        g('62', this.additionalDataField.toString().toUpperCase()) +
        g('63', crc.toUpperCase());
  }
}
