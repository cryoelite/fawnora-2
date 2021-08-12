import 'package:fawnora/services/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transectServiceProvider =
    ChangeNotifierProvider<TransectService>((ProviderReference ref) {
  final watchFirestore = ref.read(firestoreProvider);

  return TransectService(watchFirestore);
});

class TransectService extends ChangeNotifier {
  int transectVal = 1;
  FirestoreService firestoreService;
  TransectService(this.firestoreService);

  Future<void> init(String username) async {
    final val = await firestoreService.getTransectStatus(username);
    if (val != null) {
      transectVal = val;
    }
    notifyListeners();
  }

  Future<void> increment(String username) async {
    await firestoreService.increaseTransectCount(transectVal, username);
    transectVal++;
    notifyListeners();
  }
}
