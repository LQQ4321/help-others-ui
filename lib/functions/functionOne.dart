import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';

class FunctionOne {
  static dynamic switchLanguage(dynamic option) {
    if (option is int) {
      return ConstantData.supportedLanguages[option - 1];
    } else {
      for (int i = 0; i < ConstantData.supportedLanguages.length; i++) {
        if (ConstantData.supportedLanguages[i] == option) {
          return i + 1;
        }
      }
      return 0;
    }
  }
}
