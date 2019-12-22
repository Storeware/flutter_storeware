const cUFsValidas = ',AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,' +
    'RJ,RN,RS,RO,RR,SC,SP,SE,TO,EX,';

String validarUF(String uf) {
  if (!cUFsValidas.contains(uf)) return 'UF inválida';
  return '';
}
