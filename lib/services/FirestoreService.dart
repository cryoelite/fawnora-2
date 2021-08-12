import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fawnora/constants/FirestoreCollections.dart';
import 'package:fawnora/constants/FirestoreDocuments.dart';
import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/UserDataModel.dart';
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

  Future<Map<SpecieType, Map<String, List<String>>>>
      getSubspecieDocuments() async {
    final docData = await _firestoreInstance
        .collection(FirestoreCollections.mainDataCollection)
        .get();
    final Map<SpecieType, Map<String, List<String>>> mapData = {};

    for (var elem in docData.docs) {
      final data = elem.data();
      final Map<String, List<String>> convData = {};
      convData.addAll(data.map((key, value) {
        final convKey = key.toString();
        if (value is List) {
          final convList = value.map((e) => e.toString()).toList();
          return MapEntry(convKey, convList);
        } else {
          throw TypeError();
        }
      }));

      if (elem.id == FirestoreDocuments.disturbance) {
        mapData[SpecieType.DISTURBANCE] = convData;
      } else if (elem.id == FirestoreDocuments.disturbance_hindi) {
        mapData[SpecieType.DISTURBANCE_HINDI] = convData;
      } else if (elem.id == FirestoreDocuments.fauna) {
        mapData[SpecieType.FAUNA] = convData;
      } else if (elem.id == FirestoreDocuments.fauna_hindi) {
        mapData[SpecieType.FAUNA_HINDI] = convData;
      } else if (elem.id == FirestoreDocuments.flora_hindi) {
        mapData[SpecieType.FLORA_HINDI] = convData;
      } else if (elem.id == FirestoreDocuments.disturbance_hindi) {
        mapData[SpecieType.DISTURBANCE_HINDI] = convData;
      } else {
        mapData[SpecieType.FLORA] = convData;
      }
    }

    return mapData;
  }

  Future<Map<String, String>> getVersions() async {
    final docData = await _firestoreInstance
        .collection(FirestoreCollections.versionCollection)
        .get();
    final versionDoc1 =
        docData.docs[0].data()[FirestoreDocuments.version].toString();

    final versionDoc2 =
        docData.docs[1].data()[FirestoreDocuments.version].toString();
    final mapData = {
      docData.docs[0].id: versionDoc1,
      docData.docs[1].id: versionDoc2,
    };
    return mapData;
  }

  Future<int?> getTransectStatus(String username) async {
    final docData = await _firestoreInstance
        .collection(FirestoreCollections.userMetaDataCollection)
        .doc(username)
        .get();
    final data = docData.data()?[FirestoreDocuments.userTransectCount];
    return data;
  }

  Future<void> submitData(UserDataModel userDataModel) async {
    final path =
        "${FirestoreCollections.userDataCollection}/${userDataModel.state}/${userDataModel.city}/${userDataModel.username}";
    final docData = await _firestoreInstance.doc(path).get();
    String entryNo = '1';
    final entryCountPath =
        "${FirestoreCollections.userMetaDataCollection}/${userDataModel.username}";
    final metaDataDoc = await _firestoreInstance.doc(entryCountPath).get();
    final entryData = metaDataDoc.data()?[FirestoreDocuments.userTotalEntries];
    if (entryData != null) {
      final intVal = int.tryParse(entryData) ?? 0;
      entryNo = (intVal + 1).toString();
    }
    dynamic docVals = docData.data()?[FirestoreDocuments.userEntries];
    if (docVals == null) {
      docVals = Map<String, Map<String, Object>>();
    }

    final storedData = docVals;

    final specieData = {
      FirestoreDocuments.userLocation: GeoPoint(
          userDataModel.location.latitude, userDataModel.location.longitude),
      FirestoreDocuments.userSpecie: userDataModel.specie,
      FirestoreDocuments.userSpecieType: userDataModel.specieType,
      FirestoreDocuments.userSubSpecie: userDataModel.subSpecie,
      FirestoreDocuments.userTime: userDataModel.dateTime,
      FirestoreDocuments.userTransect: userDataModel.transect,
      FirestoreDocuments.userEntryLanguage: userDataModel.language,
    };
    storedData[entryNo] = specieData;

    await _firestoreInstance.doc(path).set({
      FirestoreDocuments.userEntries: storedData,
    });

    await _firestoreInstance.doc(entryCountPath).set(
        {
          FirestoreDocuments.userTotalEntries: entryNo,
        },
        SetOptions(
          merge: true,
        ));
  }

  Future<void> increaseTransectCount(int val, String username) async {
    await _firestoreInstance
        .collection(FirestoreCollections.userMetaDataCollection)
        .doc(username)
        .set(
            {
          FirestoreDocuments.userTransectCount: val,
        },
            SetOptions(
              merge: true,
            ));
  }
}
