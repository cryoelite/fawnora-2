import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProgressIndicator extends ConsumerWidget {
  const AuthProgressIndicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchAuth = watch(authenticationViewModelProvider);
    return Container(
      width: ScreenConstraintService(context).minWidth * 9,
      height: ScreenConstraintService(context).minHeight * 5,
      child: Stack(
        children: [
          Container(
            width: ScreenConstraintService(context).minWidth * 9,
            height: ScreenConstraintService(context).minHeight * 5,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                watchAuth == AuthEnum.LOADING
                    ? AppColors.color13
                    : Colors.transparent,
              ),
            ),
          ),
          Container(
            width: ScreenConstraintService(context).minWidth * 9,
            height: ScreenConstraintService(context).minHeight * 5,
            child: this.child,
          ),
        ],
      ),
    );
  }
}
