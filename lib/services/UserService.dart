import 'package:fawnora/models/EncryptedUserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((_) => UserService());

class UserService {
  EncryptedUserModel? userModel;
  UserService({this.userModel});
}
