import 'dart:async';
import 'dart:developer' as dev;

import 'package:fawnora/constants/FirestoreDocuments.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:flutter/material.dart' show Key, UniqueKey;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchManProvider = StateNotifierProvider<WatchManService, Key>((ref) {
  dev.log("WatchMan Provider Started", level: 800);
  final watchFirestore = ref.read(firestoreProvider);
  return WatchManService(watchFirestore);
});

class WatchManService extends StateNotifier<Key> {
  StreamSubscription? _streamSubscription;
  FirestoreService _firestoreService;
  WatchManService(this._firestoreService) : super(UniqueKey());

  void bumpState() {
    state = UniqueKey();
  }

  void startWatchman(String username, String devId) {
    dev.log("WatchMan Service Started", level: 800);

    _streamSubscription =
        _firestoreService.getLoggedInStream(username).listen((event) {
      final data = event.data();
      if (data != null) {
        checkKey(data, devId);
      }
    });
  }

  void checkKey(Map event, String devId) {
    final data = event[FirestoreDocumentsAndFields.userDataDeviceID];
    if (data != null && data != devId) {
      bumpState();
    }
  }

  Key get currentKey => state;

  @override
  void dispose() {
    dev.log("WatchMan Service Stopped", level: 800);

    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    super.dispose();
  }
}
