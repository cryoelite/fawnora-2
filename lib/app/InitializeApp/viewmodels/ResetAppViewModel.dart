import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowAssistiveAddWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowQuickAddViewModel.dart';
import 'package:fawnora/app/home/viewmodels/homeViewModel.dart';
import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/SearchBar/viewmodels/searchBarViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/HomeRouteConstants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetAppProvider = StateNotifierProvider<ResetAppViewModel, bool>(
    (ref) => ResetAppViewModel(ref));

class ResetAppViewModel extends StateNotifier<bool> {
  final ProviderReference _ref;
  ResetAppViewModel(this._ref) : super(false);

  Future<void> resetApp() async {
    await _ref.read(authenticationViewModelProvider.notifier).signOut();
    resetState();
  }

  void resetState() {
    _ref.read(homeRouteViewModelProvider.notifier).newState =
        HomeRouteConstants.homeVal;
    _ref.read(toShowQuickAddWidgetProvider.notifier).newState = false;
    _ref.read(toShowAssistiveAddWidgetProvider.notifier).newState = false;
    _ref.read(selectionStatusProvider.notifier).newState = null;
    _ref.read(searchBarProvider.notifier).newState = null;
    _ref.read(activeSpecieTypeIconIdProvider.notifier).resetState();
    _ref.read(activeSubSpecieIconIdProvider.notifier).resetState();
    _ref.read(dropDownValueProvider.notifier).value = null;
  }
}
