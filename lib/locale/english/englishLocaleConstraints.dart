import 'package:fawnora/locale/localeConstraints.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';

class EnglishLocaleConstraints extends LocaleConstraints {
  LocaleType get localeType => LocaleType.ENGLISH;

  String get welcomeText => 'Data Collection made easy.';
  String get loginText => 'Welcome';
  String get signUpText => 'Create Account';
  String get login => 'Sign In';
  String get signUp => 'Sign Up';
  String get forgotPassword => 'Forgot Password';
  String get compassTitle => 'Compass';
  String get homeTitle => 'GTF';
  String get submissionsTitle => 'Submissions';
  String get assistiveAddTitle => 'Assistive Add';
  String get quickAddTitle => 'Quick Add';
  String get flora => 'Flora';
  String get fauna => 'Fauna';
  String get disturbance => 'Disturbance';
  String get selectSpecie => 'Select a specie';
  String get submissionSuccess => 'Record stored successfully.';
  String get submissionFailure => 'Unknown error occured, please try again.';
  String get searchSpecie => 'Search a specie';

  String get accessCode => 'Access Code';

  String get name => 'Name';

  String get password => 'Password';

  String get phoneNumber => 'Phone Number';

  String get specie => 'Specie';

  String get specieType => 'SpecieType';

  String get subspecie => 'SubSpecie';
  String get language => 'Language';

  String get waitCompletion => 'Please wait while record is being stored.';
  String get aboutApp => 'About App';
  @override
  String itemNotFound(String item) {
    return "'$item' couldn't be found.";
  }
}
