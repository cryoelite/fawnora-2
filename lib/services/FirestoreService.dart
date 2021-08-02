import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fawnora/constants/FirestoreCollections.dart';
import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:fawnora/models/UnencryptedUserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirestoreService>(
    (_) => FirestoreService(FirebaseFirestore.instance));

class FirestoreService {
  final FirebaseFirestore _firestoreInstance;
  const FirestoreService(this._firestoreInstance);

  Future<bool> verifyUser(String username) async {
    final userCollectionData = await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .get();
    if (userCollectionData.exists) return true;
    return false;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAccessCodeDocument(
      String accessCode) async {
    final result = await _firestoreInstance
        .collection(FirestoreCollections.accessCodeCollection)
        .doc(accessCode)
        .get();
    return result;
  }

  Future<void> assignUserToAccessCode(
      String accessCode, String username) async {
    await _firestoreInstance
        .collection(FirestoreCollections.accessCodeCollection)
        .doc(accessCode)
        .set(
      {
        "Username": username,
      },
    );
  }

  Future<void> addUser(EncryptedUserModel userModel, String encrIV, String ivv,
      String devID) async {
    await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(userModel.username)
        .set(
      {
        "Name": userModel.name,
        "UserName": userModel.username,
        "Password": userModel.password,
        "IV": encrIV,
        "IVV": ivv,
        "Unique Device ID": devID,
      },
    );
  }

  Future<dynamic> getUserData(String username) async {
    final userData = await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .get();
    final data = userData.data();
    return data;
  }

  Future<void> refreshLoggedInDeviceID(String username, String deviceID) async {
    await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .set(
      {
        "Unique Device ID": deviceID,
      },
      SetOptions(
        mergeFields: ["Unique Device ID"],
      ),
    );
  }
}
