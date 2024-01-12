import 'package:help_them/data/constantData.dart';

//The email address format is incorrect
enum ErrorType {
  internalError,
  mailboxAlreadyExist,
  mailboxDoesNotExist,
  mailboxFormatIncorrect,
  inputNull,
  inputContainsSpaces,
  passwordInconsistency,
  verificationCodeExpired,
  verificationCodeError,
  usernameOrEmailAlreadyExists,
  usernameOrEmailNotExists,
  dataRequestFailure,
  operationIsTooFrequent,
  theUserIsAboutToBeBlocked,
}

Map<int, ErrorType> errorMap = {
  1: ErrorType.internalError,
  2: ErrorType.mailboxAlreadyExist,
  3: ErrorType.mailboxDoesNotExist,
  4: ErrorType.mailboxFormatIncorrect,
  5: ErrorType.inputNull,
  6: ErrorType.inputContainsSpaces,
  7: ErrorType.passwordInconsistency,
  8: ErrorType.verificationCodeExpired,
  9: ErrorType.verificationCodeError,
  10: ErrorType.usernameOrEmailAlreadyExists,
  11: ErrorType.usernameOrEmailNotExists,
  12: ErrorType.dataRequestFailure,
  13: ErrorType.operationIsTooFrequent,
  14: ErrorType.theUserIsAboutToBeBlocked,
};

class ErrorParse {
  static List<String> getErrorMessage(int option) {
    switch (option) {
      case 1:
        return [ConstantData.errorTitle[0], ConstantData.errorMessage[0]];
      case 2:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[1]];
      case 3:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[2]];
      case 4:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[3]];
      case 5:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[4]];
      case 6:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[5]];
      case 7:
        return [ConstantData.errorTitle[2], ConstantData.errorMessage[6]];
      case 8:
        return [ConstantData.errorTitle[3], ConstantData.errorMessage[7]];
      case 9:
        return [ConstantData.errorTitle[3], ConstantData.errorMessage[8]];
      case 10:
        return [ConstantData.errorTitle[3], ConstantData.errorMessage[9]];
      case 11:
        return [ConstantData.errorTitle[3], ConstantData.errorMessage[10]];
      case 12:
        return [ConstantData.errorTitle[4], ConstantData.errorMessage[0]];
      case 13:
        return [ConstantData.errorTitle[1], ConstantData.errorMessage[11]];
      case 14:
        return [ConstantData.errorTitle[5], ConstantData.errorMessage[12]];
    }
    return ['Parse fail', 'Error type not exists and cannot get error message'];
  }
}
