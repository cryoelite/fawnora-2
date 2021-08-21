import 'package:fawnora/locale/localeConstraints.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';

class HindiLocaleConstraints extends LocaleConstraints {
  LocaleType get localeType => LocaleType.HINDI;

  String get welcomeText => 'जी.टी.एफ. में आपका स्वागत है।';
  String get loginText => 'आपका स्वागत है';
  String get signUpText => 'क्रिएट अकाउंट';
  String get login => 'साइन इन';
  String get signUp => 'साइन अप';
  String get forgotPassword => 'पासवर्ड बदलें';
  String get compassTitle => 'कम्पास';
  String get homeTitle => 'जीटीएफ';
  String get submissionsTitle => 'प्रविष्टियों';
  String get assistiveAddTitle => 'सहायक प्रवेश';
  String get quickAddTitle => 'त्वरित प्रवेश';
  String get flora => 'वनस्पति';
  String get fauna => 'पशुवर्ग';
  String get disturbance => 'उपद्रव';
  String get selectSpecie => 'एक प्रजाति चुनें';
  String get submissionSuccess => 'रिकॉर्ड सफलतापूर्वक सबमिट हो गया.';
  String get submissionFailure => 'अज्ञात त्रुटि हुई, कृपया पुन: प्रयास करें।';
  String get searchSpecie => 'प्रजाति धुंडे';

  String get accessCode => 'एक्सेस कोड';

  String get name => 'नाम';

  String get password => 'पासवर्ड';

  String get phoneNumber => 'फ़ोन नंबर';

  String get specie => 'प्रजाति';

  String get specieType => 'प्रजाति प्रकार';

  String get subspecie => 'उप-प्रजाति';
  String get language => 'भाषा';

  String get waitCompletion =>
      'कृपया प्रतीक्षा करें। रिकॉर्ड जमा किया जा रहा हे।';

  String get aboutApp => 'ऐप की जानकारी';

  String get inadequatePerms =>
      'अपर्याप्त अनुमति दी गई। ऐप प्रारंभ नहीं हो सकती।';

  String get signOut => 'साइन आउट';

  @override
  String itemNotFound(String item) {
    return "'$item' जेसी कोई प्रजाति नहीं मिली।";
  }
}
