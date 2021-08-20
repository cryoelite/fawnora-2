import 'package:fawnora/models/UserDataModel.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submissionViewModelProvider =
    StateNotifierProvider<SubmissionsViewModel, List<UserDataModel>?>((ref) {
  final watchFirestore = ref.read(firestoreProvider);
  final watchUsermodel =
      ref.read(userServiceProvider).userModel?.username ?? "";
  return SubmissionsViewModel(watchUsermodel, watchFirestore);
});

class SubmissionsViewModel extends StateNotifier<List<UserDataModel>?> {
  final String _username;
  final FirestoreService _firestoreService;
  SubmissionsViewModel(this._username, this._firestoreService) : super(null);

  Future<void> init() async {
    final data = await _firestoreService.getSubmissionData(_username);
    if (data != null && data.isNotEmpty) {
      state = data;
    }
  }

  List<UserDataModel>? get currentState => state;
}
