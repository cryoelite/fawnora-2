import 'dart:developer' as dev;
import 'dart:math';

import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:fawnora/models/UnencryptedUserModel.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/GetDeviceIDService.dart';
import 'package:fawnora/services/HashingService.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<AuthService>((ref) {
  final watchFirestore = ref.watch(firestoreProvider);
  final watchDeviceID = ref.watch(deviceIDProvider);

  return AuthService(watchFirestore, watchDeviceID);
});

class AuthService {
  final FirestoreService _firestoreService;
  final GetDeviceIDService _deviceIDService;
  const AuthService(this._firestoreService, this._deviceIDService);

  Future<bool> verifyAccessCode(String accessCode, String username) async {
    dev.log("Verifying Access Code", level: 800);
    final accessCodeDoc =
        await _firestoreService.getAccessCodeDocument(accessCode);
    String? accessCodeDocValue;
    final data = accessCodeDoc.data();
    if (data != null) accessCodeDocValue = data["Username"];

    if (!accessCodeDoc.exists ||
        (accessCodeDocValue != null && accessCodeDocValue != username)) {
      return false;
    } else if (accessCodeDocValue != null && accessCodeDocValue == username) {
      return true;
    } else {
      return true;
    }
  }

  Future<void> assignUserToAccessCode(
          String accessCode, String username) async =>
      await _firestoreService.assignUserToAccessCode(accessCode, username);

  Future<bool> accessCodeRaceResolver(
      String accessCode, EncryptedUserModel userModel) async {
    final Random random = Random();
    await Future.delayed(
      Duration(
        seconds: random.nextInt(
          5,
        ),
      ),
    );
    final accessCodeDoc =
        await _firestoreService.getAccessCodeDocument(accessCode);
    String accessCodeDocValue = "";
    final data = accessCodeDoc.data();
    if (data != null) accessCodeDocValue = data["Username"];
    if (accessCodeDocValue == userModel.username) return true;
    return false;
  }

  /*  Future<String> genUID(String username) async =>
      await HashingService().genHash(username); */

  /* Future<bool> verifyUID(String userID) async {
    final value = await _firebaseInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(userID)
        .get();
    if (value.exists) return false;
    return true;
  } */

  Future<EncryptedUserModel?> signUp(UnencryptedUserModel userModel) async {
    dev.log("SignUp started", level: 800);
    try {
      HashingService hashingService = HashingService();
      final iv = hashingService.genIV();
      /* final encrUser =
          await hashingService.encrUsername(userModel.username, iv); */
      final encrName = await hashingService.encrUsername(userModel.name, iv);
      final encrPass =
          await hashingService.encrPassword(userModel.password, iv);
      final ivv = hashingService.genIV();
      final encrIV = await hashingService.encrIV(iv, ivv);
      final encrUserModel =
          EncryptedUserModel(userModel.username, encrName, encrPass);
      final deviceID = await _deviceIDService.id();
      final userStatus = await _firestoreService.verifyUser(userModel.username);
      if (!userStatus) {
        await _firestoreService.addUser(
          encrUserModel,
          encrIV,
          ivv,
          deviceID,
        );
      } else {
        return null;
      }

      return encrUserModel;
    } catch (e) {
      dev.log("Error in AuthService. $e", level: 800);
      return null;
    }
  }

  Future<EncryptedUserModel?> signIn(String username, String pass) async {
    dev.log("SignIn started.", level: 800);
    try {
      final data = await _firestoreService.getUserData(username);
      final hashingService = HashingService();

      if (data == null) return null;
      final String? password = data["Password"];

      final String? iv = data["IV"];

      final String? ivv = data["IVV"];
      if (password == null ||
          iv == null ||
          ivv == null ||
          password == "" ||
          iv == "" ||
          ivv == "") return null;
      final String decrIV = await hashingService.decrIV(iv, ivv);

      final String decrPassword =
          await hashingService.decrPassword(password, decrIV);

      if (decrPassword != pass) return null;
      final userModel =
          EncryptedUserModel(username, data["name"] ?? "", password);

      final deviceID = await GetDeviceIDService().id();

      await _firestoreService.refreshLoggedInDeviceID(username, deviceID);
      return userModel;
    } catch (e) {
      dev.log("Error in AuthService. $e", level: 800);
      return null;
    }
  }
}
