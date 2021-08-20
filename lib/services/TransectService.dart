import 'dart:developer' as dev;
import 'package:fawnora/services/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transectServiceProvider =
    ChangeNotifierProvider<TransectService>((ProviderReference ref) {
  final watchFirestore = ref.read(firestoreProvider);
  dev.log('TransectService Provider started', level: 800);
  return TransectService(watchFirestore);
});

class TransectService extends ChangeNotifier {
  final _className = 'TransectService';
  int transectVal = 1;
  FirestoreService firestoreService;
  TransectService(this.firestoreService);

  Future<void> init(String username) async {
    dev.log('$_className: Initializing', level: 800);

    final val = await firestoreService.getTransectStatus(username);
    if (val != null) {
      transectVal = val;
    }

    dev.log('$_className: Initializing complete', level: 800);

    notifyListeners();
  }

  Future<void> increment(String username) async {
    dev.log('$_className: Incrementing transect value', level: 800);

    await firestoreService.increaseTransectCount(transectVal, username);
    transectVal++;

    dev.log(
        '$_className: Incremented transect value.Current transect value $transectVal',
        level: 800);

    notifyListeners();
  }
}
