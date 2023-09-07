import 'dart:math';

import 'package:easy_mask/easy_mask.dart';
import 'package:intl/intl.dart';

import '../database/pix_key_type.dart';

/// Retorna um número no formato de máscara R$ ddd,dd
String putCurrencyMask(num? value, {bool showCurrencyLabel = true}) {
  List splitParts = value.toString().split('.');
  int numGroups = splitParts[0].length ~/ 3;
  int numResidual = splitParts[0].length % 3;

  String formattedNumber = showCurrencyLabel ? 'R\$ ' : '';
  if (numResidual > 0) {
    formattedNumber += numGroups > 0 ? splitParts[0].substring(0, numResidual) + '.' : splitParts[0].substring(0, numResidual);
  }
  for (int i = 0; i < numGroups; i++) {
    formattedNumber += (i < numGroups - 1)
        ? splitParts[0].substring(numResidual + 3 * i, numResidual + 3 + 3 * i) + '.'
        : splitParts[0].substring(numResidual + 3 * i, numResidual + 3 + 3 * i);
  }
  formattedNumber += ',${splitParts[1].toString().padRight(2, '0')}';

  return formattedNumber;
}

/// Retorna a data no formato dd/MM/yyyy ou no formato dd/MM/yyy HH:mm:ss
String convertDateToBrazilianFormat(DateTime dateTime, {bool shownOnlyDate = true}) {
  DateFormat formatter;
  if (shownOnlyDate) {
    formatter = DateFormat('dd/MM/yyyy');
  } else {
    formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  }
  return formatter.format(dateTime);
}

/// Gera uma chave aleatória Pix. Exemplo: 4c04c042-def5-46cd-bdac-4366fb8754d9
String generateAleatoryKeyPix() {
  String aleatoryKeyPix = "";

  for (int i = 1; i <= 36; i++) {
    if (i == 9 || i == 14 || i == 19 || i == 24) {
      aleatoryKeyPix += '-';
    } else {
      aleatoryKeyPix += _generateRandomString(1);
    }
  }
  return aleatoryKeyPix;
}

String _generateRandomString(int len) {
  var r = Random();
  const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

/// Adiciona uma máscara ao campo de acordo com o tipo de chave pix que ele representa
TextInputMask defineMaskforSelectedKey(EnumPixKeyType enumPixKeyType) {
  String mask = "";
  String placeholder = "";
  int maxPlaceHolders = 0;
  bool reverse = false;

  switch (enumPixKeyType) {
    case EnumPixKeyType.cpf_cnpj:
      mask = '999.999.999-99,99.999.999/9999-99';
      placeholder = ' ';
      maxPlaceHolders = 1;
      reverse = true;
      break;
    case EnumPixKeyType.chave_aleatoria:
      //exemplo de chave: f9f4fd0c-fad1-44d8-9ce1-1963a0656816
      mask = 'NNNNNNNN-NNNN-NNNN-NNNN-NNNNNNNNNNNN';
      placeholder = '0';
      maxPlaceHolders = 1;
      reverse = false;
      break;
    case EnumPixKeyType.telefone:
      mask = '\(99) 99999-9999';
      placeholder = '0';
      maxPlaceHolders = 1;
      reverse = false;

      break;
    case EnumPixKeyType.email:

      mask = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
      placeholder = '0';
      maxPlaceHolders = 1;
      reverse = false;

      break;
    default:
      break;
  }

  return TextInputMask(
    mask: mask.split(','),
    placeholder: placeholder,
    maxPlaceHolders: maxPlaceHolders,
    reverse: reverse,
  );
}
