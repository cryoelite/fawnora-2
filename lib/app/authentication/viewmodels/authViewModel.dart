import 'package:fawnora/app/authentication/Widgets/AuthValidator.dart';
import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/models/UnencryptedUserModel.dart';
import 'package:fawnora/services/AuthService.dart';
import 'package:fawnora/services/DataSanitizerService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:fawnora/services/TransectService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthEnum>(
        (ref) => AuthenticationViewModel(ref));

class AuthenticationViewModel extends StateNotifier<AuthEnum> {
  final AuthValidator _validator = AuthValidator();
  AuthenticationViewModel(
    this._providerReference,
  ) : super(AuthEnum.NONE);
  final ProviderReference _providerReference;

  Future<AuthEnum> autoLogin(MapEntry<String, String> userData) async {
    final username = DataSanitizerService().decodeString(userData.key);
    final password = DataSanitizerService().decodeString(userData.value);
    await signIn(username, password);
    return state;
  }

  Future<void> signOut() async {
    await _providerReference.read(localStorageProvider).clearLoginCredentials();
  }

  Future<void> signIn(String username, String password) async {
    state = AuthEnum.LOADING;
    if (_validator.isUsernameGood(username) &&
        _validator.isPasswordGood(password)) {
      final watchAuth = _providerReference.watch(firebaseAuthProvider);
      final response = await watchAuth.signIn(username, password);
      if (response != null) {
        _providerReference.watch(userServiceProvider).userModel = response;
        await _providerReference.read(transectServiceProvider).init(username);
        await _storeAutoLoginData(username, password);

        state = AuthEnum.SUCCESS;

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
    state = AuthEnum.LOADING;
    if (_validator.isAccessCodeGood(accessCode) &&
        _validator.isNameGood(name) &&
        _validator.isPasswordGood(password) &&
        _validator.isUsernameGood(username)) {
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
        await _providerReference.read(transectServiceProvider).init(username);

        await _storeAutoLoginData(username, password);
        state = AuthEnum.SUCCESS;
        await watchAuth.assignUserToAccessCode(accessCode, username);

        return;
      }
    } else {
      state = AuthEnum.INCOMPLETE_FORM;
      return;
    }
  }

  Future<void> _storeAutoLoginData(String username, String password) async {
    final convUsername = DataSanitizerService().encodeString(username);
    final convPassword = DataSanitizerService().encodeString(password);
    await _providerReference
        .read(localStorageProvider)
        .storeLoginCredentials(convUsername, convPassword);
  }

  void resetState() {
    state = AuthEnum.NONE;
  }

  AuthEnum get currentState => state;
}
