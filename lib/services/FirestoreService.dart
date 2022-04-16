import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fawnora/constants/FirestoreCollections.dart';
import 'package:fawnora/constants/FirestoreDocuments.dart';
import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/UserDataModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final firestoreProvider = Provider<FirestoreService>((_) {
  dev.log('Firestore Provider Started');
  return FirestoreService(FirebaseFirestore.instance);
});

class FirestoreService {
  final _className = 'Firestore';
  final _seperatingCharacter = '%';
  final FirebaseFirestore _firestoreInstance;
  const FirestoreService(this._firestoreInstance);

  Future<bool> verifyUser(String username) async {
    dev.log("$_className: Verifying user", level: 800);

    final userCollectionData = await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .get();
    if (userCollectionData.exists) {
      dev.log("$_className: Verifying user complete with success", level: 800);

      return true;
    }

    dev.log("$_className: Verifying user complete with failure", level: 800);

    return false;
  }

  Future<Map<String, dynamic>> getAccessCodeDocument(String accessCode) async {
    dev.log("$_className: Getting access code document", level: 800);

    final result = await _firestoreInstance
        .collection(FirestoreCollections.accessCodeCollection)
        .doc(accessCode)
        .get();
    final data = result.data();

    dev.log("$_className: Getting access code document complete", level: 800);

    return data ?? {};
  }

  Future<void> assignUserToAccessCode(
      String accessCode, String username) async {
    dev.log("$_className: Assigning user to access code", level: 800);

    await _firestoreInstance
        .collection(FirestoreCollections.accessCodeCollection)
        .doc(accessCode)
        .set(
      {
        "Username": username,
      },
    );

    dev.log("$_className: Assigning user to access code complete", level: 800);
  }

  Future<void> addUser(EncryptedUserModel userModel, String encrIV, String ivv,
      String devID) async {
    dev.log("$_className: Adding user to firestore", level: 800);

    await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(userModel.username)
        .set(
      {
        FirestoreDocumentsAndFields.userDataName: userModel.name,
        FirestoreDocumentsAndFields.userDataUserName: userModel.username,
        FirestoreDocumentsAndFields.userDataPassword: userModel.password,
        FirestoreDocumentsAndFields.userDataIV: encrIV,
        FirestoreDocumentsAndFields.userDataIVV: ivv,
        FirestoreDocumentsAndFields.userDataDeviceID: devID,
      },
    );

    dev.log("$_className: Adding user to firestore complete", level: 800);
  }

  Future<Map<String, dynamic>?> getUserData(String username) async {
    dev.log("$_className: Getting user data", level: 800);

    final userData = await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .get();
    Map<String, dynamic>? data = {};
    if (userData.exists) {
      data = userData.data();
    }

    dev.log("$_className: Getting user data complete", level: 800);

    return data;
  }

  Future<void> refreshLoggedInDeviceID(String username, String deviceID) async {
    dev.log("$_className: Refreshing logged in device id", level: 800);

    await _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .set(
      {
        FirestoreDocumentsAndFields.userDataDeviceID: deviceID,
      },
      SetOptions(
        mergeFields: [FirestoreDocumentsAndFields.userDataDeviceID],
      ),
    );
    dev.log("$_className: Refreshing logged in device id complete", level: 800);
  }

  Future<Map<SpecieType, Map<String, List<String>>>>
      getSubspecieDocuments() async {
    dev.log("$_className: Getting subspecie documents", level: 800);

    final docData = await _firestoreInstance
        .collection(FirestoreCollections.mainDataCollection)
        .get();
    final Map<SpecieType, Map<String, List<String>>> mapData = {};

    for (var elem in docData.docs) {
      final data = elem.data();
      final Map<String, List<String>> convData = {};
      convData.addAll(data.map((key, value) {
        final convKey = key.toString().trim();
        if (value is List && value.isNotEmpty) {
          final convList = value.map((e) => e.toString()).toList();
          return MapEntry(convKey, convList);
        } else {
          return MapEntry(convKey, []);
        }
      }));

      if (elem.id == FirestoreDocumentsAndFields.disturbance) {
        mapData[SpecieType.DISTURBANCE] = convData;
      } else if (elem.id == FirestoreDocumentsAndFields.disturbance_hindi) {
        mapData[SpecieType.DISTURBANCE_HINDI] = convData;
      } else if (elem.id == FirestoreDocumentsAndFields.fauna) {
        mapData[SpecieType.FAUNA] = convData;
      } else if (elem.id == FirestoreDocumentsAndFields.fauna_hindi) {
        mapData[SpecieType.FAUNA_HINDI] = convData;
      } else if (elem.id == FirestoreDocumentsAndFields.flora_hindi) {
        mapData[SpecieType.FLORA_HINDI] = convData;
      } else if (elem.id == FirestoreDocumentsAndFields.disturbance_hindi) {
        mapData[SpecieType.DISTURBANCE_HINDI] = convData;
      } else {
        mapData[SpecieType.FLORA] = convData;
      }
    }
    dev.log("$_className: Getting subspecie documents complete", level: 800);

    return mapData;
  }

  Future<Map<String, String>> getVersions() async {
    dev.log("$_className: Getting versions", level: 800);

    final docData = await _firestoreInstance
        .collection(FirestoreCollections.versionCollection)
        .get();
    final versionDoc1 =
        docData.docs[0].data()[FirestoreDocumentsAndFields.version].toString();

    final versionDoc2 =
        docData.docs[1].data()[FirestoreDocumentsAndFields.version].toString();
    final mapData = {
      docData.docs[0].id: versionDoc1,
      docData.docs[1].id: versionDoc2,
    };

    dev.log("$_className: Getting versions complete", level: 800);

    return mapData;
  }

  Future<int?> getTransectStatus(String username) async {
    dev.log("$_className: Getting transect count", level: 800);

    final docData = await _firestoreInstance
        .collection(FirestoreCollections.userMetaDataCollection)
        .doc(username)
        .get();
    final data = docData.data()?[FirestoreDocumentsAndFields.userTransectCount];

    dev.log("$_className: Getting transect count complete", level: 800);

    return data;
  }

  Future<void> submitData(UserDataModel userDataModel) async {
    dev.log("$_className: Submitting specie data", level: 800);

    final path =
        "${FirestoreCollections.userDataCollection}/${userDataModel.state}$_seperatingCharacter${userDataModel.city}$_seperatingCharacter${userDataModel.username}";
    final docData = await _firestoreInstance.doc(path).get();
    String entryNo = '1';
    final entryCountPath =
        "${FirestoreCollections.userMetaDataCollection}/${userDataModel.username}";
    final metaDataDoc = await _firestoreInstance.doc(entryCountPath).get();
    final entryData =
        metaDataDoc.data()?[FirestoreDocumentsAndFields.userTotalEntries];
    if (entryData != null) {
      final intVal = int.tryParse(entryData) ?? 0;
      entryNo = (intVal + 1).toString();
    }
    dynamic docVals = docData.data()?[FirestoreDocumentsAndFields.userEntries];
    if (docVals == null ||
        !(docVals is Map) ||
        (docVals is Map && docVals.isEmpty)) {
      docVals = Map<String, Map<String, Object?>>();
    }

    final storedData = docVals;

    final specieData = {
      FirestoreDocumentsAndFields.userLocation: GeoPoint(
          userDataModel.location.latitude, userDataModel.location.longitude),
      FirestoreDocumentsAndFields.userSpecie: userDataModel.specie,
      FirestoreDocumentsAndFields.userSpecieType: userDataModel.specieType,
      FirestoreDocumentsAndFields.userSubSpecie: userDataModel.subSpecie,
      FirestoreDocumentsAndFields.userTime: userDataModel.dateTime,
      FirestoreDocumentsAndFields.userTransect: userDataModel.transect,
      FirestoreDocumentsAndFields.userEntryLanguage: userDataModel.language,
      FirestoreDocumentsAndFields.userImageName: userDataModel.imageName,
      FirestoreDocumentsAndFields.userCity: userDataModel.city,
      FirestoreDocumentsAndFields.userState: userDataModel.state,
    };

    storedData[entryNo] = specieData;

    await _firestoreInstance.doc(path).set({
      FirestoreDocumentsAndFields.userEntries: storedData,
    });

    await _firestoreInstance.doc(entryCountPath).set(
        {
          FirestoreDocumentsAndFields.userTotalEntries: entryNo,
        },
        SetOptions(
          merge: true,
        ));

    dev.log("$_className: Submitting specie data complete", level: 800);
  }

  Future<void> increaseTransectCount(int val, String username) async {
    dev.log("$_className: Bump transect count up", level: 800);

    await _firestoreInstance
        .collection(FirestoreCollections.userMetaDataCollection)
        .doc(username)
        .set(
            {
          FirestoreDocumentsAndFields.userTransectCount: val,
        },
            SetOptions(
              merge: true,
            ));

    dev.log("$_className: Bump transect count up complete", level: 800);
  }

  Future<Map<String, Map<String, String>>?> getImageMap() async {
    dev.log("$_className: Getting image map", level: 800);

    final docData = await _firestoreInstance
        .collection(FirestoreCollections.imageDataCollection)
        .doc(FirestoreDocumentsAndFields.imageMap)
        .get();
    if (!docData.exists) {
      return null;
    }

    final data = docData.data();

    Map<String, Map<String, String>>? convData = data?.map((key, value) {
      final convKey = key.toString();
      if (value is Map && value.isNotEmpty) {
        final val1 = value.entries.first.key.toString();
        final val2 = value.entries.first.value.toString();
        return MapEntry(convKey, {val1: val2});
      } else {
        return MapEntry(convKey, <String, String>{});
      }
    });

    if (convData == null) {
      convData = <String, Map<String, String>>{};
    }

    dev.log("$_className: Getting image map complete", level: 800);

    return convData;
  }

  Stream<DocumentSnapshot<Map>> getLoggedInStream(String username) {
    dev.log("$_className: Getting Login device stream", level: 800);

    final data = _firestoreInstance
        .collection(FirestoreCollections.usersCollection)
        .doc(username)
        .snapshots();

    dev.log("$_className: Getting Login device stream complete", level: 800);

    return data;
  }

  Future<List<UserDataModel>?> getSubmissionData(String username) async {
    dev.log("$_className: Getting user data", level: 800);
    final docs = await _firestoreInstance
        .collection(FirestoreCollections.userDataCollection)
        .get();
    final List<UserDataModel> listData = [];
    if (docs.docs.isNotEmpty) {
      for (final elem in docs.docs) {
        final data = elem
            .data()
            .putIfAbsent(FirestoreDocumentsAndFields.userEntries, () => null);
        final elemString = elem.id.split(_seperatingCharacter);

        if (data != null &&
            data.entries.isNotEmpty &&
            elemString[2] == username) {
          for (final docData in data.entries) {
            if (docData.value?[FirestoreDocumentsAndFields.userLocation] !=
                null) {
              GeoPoint userLocation =
                  docData.value?[FirestoreDocumentsAndFields.userLocation];
              final convUserLocation =
                  LatLng(userLocation.latitude, userLocation.longitude);
              final userSpecie =
                  docData.value?[FirestoreDocumentsAndFields.userSpecie];
              final userSpecieType =
                  docData.value?[FirestoreDocumentsAndFields.userSpecieType];
              final userSubSpecie =
                  docData.value?[FirestoreDocumentsAndFields.userSpecieType];
              Timestamp timeData =
                  docData.value?[FirestoreDocumentsAndFields.userTime] ??
                      Timestamp.now();
              final convTimeData = timeData.toDate();
              int userTransect =
                  docData.value?[FirestoreDocumentsAndFields.userTransect] ?? 1;
              final userLanguage =
                  docData.value?[FirestoreDocumentsAndFields.userEntryLanguage];
              final city = elemString[1];
              final state = elemString[0];

              if (userSpecie != null &&
                  userSpecieType != null &&
                  userSubSpecie != null) {
                final userModel = UserDataModel(
                  username,
                  userSpecie.toString(),
                  userSpecieType.toString(),
                  userSubSpecie.toString(),
                  convUserLocation,
                  city,
                  state,
                  convTimeData,
                  userTransect,
                  userLanguage.toString(),
                  null,
                );
                listData.add(userModel);
              }
            }
          }
        }
      }
    } else {
      return null;
    }

    dev.log("$_className: Getting user data complete", level: 800);
    return listData;
  }

  /* Future<void> englishNameImageListFiller(
      List<String> imageNames, List<String> specieNamesEnglish) async {
    final Map<String, Map<String, String>> entryData = {};
    for (var elem in imageNames) {
      Map<String, double> matchList = {};
      for (var specie in specieNamesEnglish) {
        final score = StringSimilarityCalculator(elem, specie).alikeness;
        matchList[specie] = score;
      }
      final leastScoreList = matchList.entries.toList()
        ..sort(
          (MapEntry<String, double> first, MapEntry<String, double> second) {
            if (first.value > second.value) {
              return 1;
            } else if (first.value < second.value) {
              return -1;
            } else {
              return 0;
            }
          },
        );
      final leastScoreValue = leastScoreList.first.key;
      final Map<String, String> entry = {};
      entry[FirestoreDocumentsAndFields.imageMapEnglish] = leastScoreValue;
      entryData[elem] = entry;
    }

    for (final entry in entryData.entries) {
      await _firestoreInstance
          .collection(FirestoreCollections.imageDataCollection)
          .doc(FirestoreDocumentsAndFields.imageMap)
          .set(
              {
            entry.key: entry.value,
          },
              SetOptions(
                merge: true,
              ));
    }
  } */
}


//Methods for alternative storage of entries
/*Future<List<UserDataModel>?> getSubmissionData(String username) async {
    dev.log("$_className: Getting user data", level: 800);
    final docs = await _firestoreInstance
        .collection(FirestoreCollections.userDataCollection)
        .get();
    final List<UserDataModel> listData = [];
    if (docs.docs.isNotEmpty) {
      for (final elem in docs.docs) {
        final elemString = elem.id.split(_seperatingCharacter);

        if (elemString[2] == username) {
          final elemData = elem.data();

          for (final data in elemData.entries) {
            final docData = data.value;
            if (docData?[FirestoreDocumentsAndFields.userLocation] != null) {
              GeoPoint userLocation =
                  docData[FirestoreDocumentsAndFields.userLocation];
              final convUserLocation =
                  LatLng(userLocation.latitude, userLocation.longitude);
              final userSpecie =
                  docData[FirestoreDocumentsAndFields.userSpecie];
              final userSpecieType =
                  docData[FirestoreDocumentsAndFields.userSpecieType];
              final userSubSpecie =
                  docData[FirestoreDocumentsAndFields.userSpecieType];
              Timestamp timeData =
                  docData[FirestoreDocumentsAndFields.userTime] ??
                      Timestamp.now();
              final convTimeData = timeData.toDate();
              int userTransect =
                  docData[FirestoreDocumentsAndFields.userTransect] ?? 1;
              final userLanguage =
                  docData[FirestoreDocumentsAndFields.userEntryLanguage];
              final city = elemString[1];
              final state = elemString[0];

              if (userSpecie != null &&
                  userSpecieType != null &&
                  userSubSpecie != null) {
                final userModel = UserDataModel(
                  username,
                  userSpecie.toString(),
                  userSpecieType.toString(),
                  userSubSpecie.toString(),
                  convUserLocation,
                  city,
                  state,
                  convTimeData,
                  userTransect,
                  userLanguage.toString(),
                  null,
                );
                listData.add(userModel);
              }
            }
          }
        }
      }
    } else {
      return null;
    }

    dev.log("$_className: Getting user data complete", level: 800);
    return listData;
  }


  Future<void> submitData(UserDataModel userDataModel) async {
    dev.log("$_className: Submitting specie data", level: 800);

    final path =
        "${FirestoreCollections.userDataCollection}/${userDataModel.state}$_seperatingCharacter${userDataModel.city}$_seperatingCharacter${userDataModel.username}";
    String entryNo = '1';
    final entryCountPath =
        "${FirestoreCollections.userMetaDataCollection}/${userDataModel.username}";
    final metaDataDoc = await _firestoreInstance.doc(entryCountPath).get();
    final entryData =
        metaDataDoc.data()?[FirestoreDocumentsAndFields.userTotalEntries];
    if (entryData != null) {
      final intVal = int.tryParse(entryData) ?? 0;
      entryNo = (intVal + 1).toString();
    }

    final specieData = {
      FirestoreDocumentsAndFields.userLocation: GeoPoint(
          userDataModel.location.latitude, userDataModel.location.longitude),
      FirestoreDocumentsAndFields.userSpecie: userDataModel.specie,
      FirestoreDocumentsAndFields.userSpecieType: userDataModel.specieType,
      FirestoreDocumentsAndFields.userSubSpecie: userDataModel.subSpecie,
      FirestoreDocumentsAndFields.userTime: userDataModel.dateTime,
      FirestoreDocumentsAndFields.userTransect: userDataModel.transect,
      FirestoreDocumentsAndFields.userEntryLanguage: userDataModel.language,
      FirestoreDocumentsAndFields.userImageName: userDataModel.imageName,
    };

    await _firestoreInstance.doc(path).set(
        {
          entryNo: specieData,
        },
        SetOptions(
          merge: true,
        ));

    await _firestoreInstance.doc(entryCountPath).set(
        {
          FirestoreDocumentsAndFields.userTotalEntries: entryNo,
        },
        SetOptions(
          merge: true,
        ));

    dev.log("$_className: Submitting specie data complete", level: 800);
  }

  */