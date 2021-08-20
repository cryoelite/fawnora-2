import 'package:fawnora/models/AuthEnum.dart';

class AuthValidator {
  bool isNameGood(String name) {
    if (name.isNotEmpty && name.length >= 3) {
      return true;
    } else {
      return false;
    }
  }

  bool isUsernameGood(String username) {
    if (username.isNotEmpty && username.length == 10) {
      return true;
    } else {
      return false;
    }
  }

  bool isAccessCodeGood(String accessCode) {
    if (accessCode.isNotEmpty && accessCode.length >= 4) {
      return true;
    } else {
      return false;
    }
  }

  bool _passwordStatus(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    final status = regex.hasMatch(password);
    return status;
  }

  bool isPasswordGood(String password) {
    if (password.isNotEmpty && _passwordStatus(password)) {
      return true;
    } else {
      return false;
    }
  }

  String? validatePassword(String password) {
    if (isPasswordGood(password)) {
      return null;
    } else if (password.isNotEmpty && !_passwordStatus(password)) {
      return "Password needs 1 upper case, 1 lower case, 1 digit, 1 special character and 8+ chars.";
    } else {
      return null;
    }
  }

  String? validateName(String name) {
    if (isNameGood(name)) {
      return null;
    } else if (name.isNotEmpty && name.length < 3) {
      return "Name must be >3 letters.";
    } else {
      return null;
    }
  }

  String? validateUsername(String username) {
    if (isUsernameGood(username)) {
      return null;
    } else if (username.isNotEmpty && username.length < 10) {
      return "Phone Number must be 10 digits long.";
    } else {
      return null;
    }
  }

  String? validateAccessCode(String accessCode) {
    if (isAccessCodeGood(accessCode)) {
      return null;
    } else if (accessCode.isNotEmpty && accessCode.length < 4) {
      return "Access Code must be >=4 digits long.";
    } else {
      return null;
    }
  }

  String? errorBuilder(AuthEnum authEnum) {
    if (authEnum == AuthEnum.NONE || authEnum == AuthEnum.SUCCESS)
      return null;
    else if (authEnum == AuthEnum.BAD_ACCESS_CODE)
      return "Access Code Invalid/Used";
    else if (authEnum == AuthEnum.FAILED_SIGN_IN)
      return "Sign In Failed. Please check username & password then try again.";
    else if (authEnum == AuthEnum.FAILED_SIGN_UP)
      return "Sign Up Failed. Please try again.";
    else if (authEnum == AuthEnum.INCOMPLETE_FORM)
      return "Incomplete/Incorrect value in fields.";
    else
      return null;
  }
}
