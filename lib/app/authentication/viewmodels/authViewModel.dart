import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/models/UnencryptedUserModel.dart';
import 'package:fawnora/services/AuthService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthEnum>(
        (ref) => AuthenticationViewModel(ref));

class AuthenticationViewModel extends StateNotifier<AuthEnum> {
  AuthenticationViewModel(
    this._providerReference,
  ) : super(AuthEnum.NONE);
  final ProviderReference _providerReference;
  bool _isNameGood(String name) {
    if (name.isNotEmpty && name.length >= 3) {
      return true;
    } else {
      return false;
    }
  }

  bool _isUsernameGood(String username) {
    if (username.isNotEmpty && username.length == 10) {
      return true;
    } else {
      return false;
    }
  }

  bool _isAccessCodeGood(String accessCode) {
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

  bool _isPasswordGood(String password) {
    if (password.isNotEmpty && _passwordStatus(password)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signIn(String username, String password) async {
    if (_isUsernameGood(username) && _isPasswordGood(password)) {
      print("in here");
      final watchAuth = _providerReference.watch(firebaseAuthProvider);
      final response = await watchAuth.signIn(username, password);
      if (response != null) {
        state = AuthEnum.SUCCESS;
        _providerReference.watch(userServiceProvider).userModel = response;
        return;
      } else {
        state = AuthEnum.FAILED_SIGN_IN;
        return;
      }
    } else {
      state = AuthEnum.INCOMPLETE_FORM;
      return;
    }
  }

  Future<void> signUp(
      String username, String password, String name, String accessCode) async {
    if (_isAccessCodeGood(accessCode) &&
        _isNameGood(name) &&
        _isPasswordGood(password) &&
        _isUsernameGood(username)) {
      final watchAuth = _providerReference.watch(firebaseAuthProvider);
      final status = await watchAuth.verifyAccessCode(accessCode, username);
      if (!status) {
        state = AuthEnum.BAD_ACCESS_CODE;
        return;
      }
      final userModel = UnencryptedUserModel(username, name, password);
      final response = await watchAuth.signUp(userModel);
      if (response == null) {
        state = AuthEnum.FAILED_SIGN_UP;
        return;
      } else {
        _providerReference.watch(userServiceProvider).userModel = response;
        state = AuthEnum.SUCCESS;
        await watchAuth.assignUserToAccessCode(accessCode, username);

        return;
      }
    } else {
      state = AuthEnum.INCOMPLETE_FORM;
      return;
    }
  }

  String? validatePassword(String password) {
    if (_isPasswordGood(password)) {
      return null;
    } else if (password.isNotEmpty && !_passwordStatus(password)) {
      return "Password needs 1 upper case, 1 lower case, 1 digit, 1 special character and 8+ chars.";
    } else {
      return null;
    }
  }

  String? validateName(String name) {
    if (_isNameGood(name)) {
      return null;
    } else if (name.isNotEmpty && name.length < 3) {
      return "Name must be >3 letters.";
    } else {
      return null;
    }
  }

  String? validateUsername(String username) {
    if (_isUsernameGood(username)) {
      return null;
    } else if (username.isNotEmpty && username.length < 10) {
      return "Phone Number must be 10 digits long.";
    } else {
      return null;
    }
  }

  String? validateAccessCode(String accessCode) {
    if (_isAccessCodeGood(accessCode)) {
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

  void resetState() {
    state = AuthEnum.NONE;
  }

  AuthEnum get currentState => state;
}
