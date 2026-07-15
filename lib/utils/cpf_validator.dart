class CPFValidator {
  static bool validar(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }

    int dig1 = 11 - (soma % 11);
    if (dig1 >= 10) dig1 = 0;
    if (dig1 != int.parse(cpf[9])) return false;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }

    int dig2 = 11 - (soma % 11);
    if (dig2 >= 10) dig2 = 0;

    return dig2 == int.parse(cpf[10]);
  }
}
