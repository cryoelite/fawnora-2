import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropDownValueProvider =
    ChangeNotifierProvider<ValueNotifier<String?>>((_) => ValueNotifier(null));
