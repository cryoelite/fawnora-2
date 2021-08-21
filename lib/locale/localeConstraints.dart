import 'package:fawnora/models/LocaleTypeEnum.dart';

abstract class LocaleConstraints {
  LocaleType get localeType;
  String get welcomeText;
  String get loginText;
  String get signUpText;
  String get phoneNumber;
  String get password;
  String get accessCode;
  String get name;
  String get login;
  String get signUp;
  String get forgotPassword;
  String get homeTitle;
  String get submissionsTitle;
  String get compassTitle;
  String get assistiveAddTitle;
  String get quickAddTitle;
  String get flora;
  String get fauna;
  String get disturbance;
  String get selectSpecie;
  String get submissionSuccess;
  String get submissionFailure;
  String get searchSpecie;
  String get specie;
  String get subspecie;
  String get specieType;
  String get language;
  String get waitCompletion;
  String get aboutApp;
  String get inadequatePerms;
  String get signOut;
  String itemNotFound(String item);
}
