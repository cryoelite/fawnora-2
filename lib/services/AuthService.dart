import 'dart:developer' as dev;

import 'package:fawnora/constants/FirestoreDocuments.dart';
import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:fawnora/models/UnencryptedUserModel.dart';
import 'package:fawnora/services/DeviceID.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/app/InitializeApp/viewmodels/WatchManViewModel.dart';
import 'package:fawnora/services/HashingService.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<AuthService>((ref) {
  dev.log("Auth Provider started", level: 800);
  final watchman = ref.read(watchManViewModelProvider.notifier);
  final watchFirestore = ref.read(firestoreProvider);
  return AuthService(watchFirestore, watchman);
});

class AuthService {
  final _className = 'AuthService';
  final FirestoreService _firestoreService;
  final WatchManService _watchManService;
  const AuthService(this._firestoreService, this._watchManService);

  Future<bool> verifyAccessCode(String accessCode, String username) async {
    dev.log("$_className: Verifying Access Code", level: 800);
    final accessCodeDoc =
        await _firestoreService.getAccessCodeDocument(accessCode);
    String? accessCodeDocValue;
    final data = accessCodeDoc;
    if (data.isNotEmpty)
      accessCodeDocValue = data.putIfAbsent(
          FirestoreDocumentsAndFields.userDataUserName, () => null);

    if (accessCodeDoc.isNotEmpty ||
        (accessCodeDocValue != null && accessCodeDocValue != username)) {
      dev.log("$_className: Verifying Access Code complete", level: 800);

      return false;
    } else if (accessCodeDocValue != null && accessCodeDocValue == username) {
      dev.log("$_className: Verifying Access Code complete", level: 800);

      return true;
    } else {
      dev.log("$_className: Verifying Access Code complete", level: 800);

      return true;
    }
  }

  Future<void> assignUserToAccessCode(
      String accessCode, String username) async {
    dev.log("$_className: Assigning user to access code", level: 800);

    await _firestoreService.assignUserToAccessCode(accessCode, username);
  }

  /*  Future<bool> accessCodeRaceResolver(
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
  } */

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
    dev.log("$_className: SignUp started", level: 800);
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
      final deviceID = await DeviceID().getDeviceid();
      final userStatus = await _firestoreService.verifyUser(userModel.username);
      if (!userStatus) {
        await _firestoreService.addUser(
          encrUserModel,
          encrIV,
          ivv,
          deviceID,
        );
      } else {
        dev.log("$_className: SignUp failed", level: 800);

        return null;
      }

      _watchManService.startWatchman(userModel.username, deviceID);
      dev.log("$_className: SignUp complete", level: 800);

      return encrUserModel;
    } catch (e) {
      dev.log("$_className: Error in AuthService. $e", level: 800);
      return null;
    }
  }

  Future<EncryptedUserModel?> signIn(String username, String pass) async {
    dev.log("$_className: SignIn started.", level: 800);
    try {
      final data = await _firestoreService.getUserData(username);
      final hashingService = HashingService();

      if (data == null) return null;
      final String? password =
          data[FirestoreDocumentsAndFields.userDataPassword];

      final String? iv = data[FirestoreDocumentsAndFields.userDataIV];

      final String? ivv = data[FirestoreDocumentsAndFields.userDataIVV];
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
      final userModel = EncryptedUserModel(username,
          data[FirestoreDocumentsAndFields.userDataName] ?? "", password);

      final deviceID = await DeviceID().getDeviceid();

      await _firestoreService.refreshLoggedInDeviceID(username, deviceID);

      _watchManService.startWatchman(userModel.username, deviceID);

      dev.log("$_className: SignIn complete.", level: 800);

      return userModel;
    } catch (e) {
      dev.log("$_className: Error in AuthService. $e", level: 800);
      return null;
    }
  }
}
