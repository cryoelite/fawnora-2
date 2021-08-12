import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/models/SpecieValueTypeEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonIcon extends StatelessWidget {
  final SpecieModel _specieModel;

  const ButtonIcon(this._specieModel, {Key? key}) : super(key: key);

  SpecieModel? _getProvider(ScopedReader watch) {
    if (_specieModel.specieValueType == SpecieValueType.SPECIETYPE) {
      return watch(activeSpecieTypeIconIdProvider);
    } else if (_specieModel.specieValueType == SpecieValueType.SUBSPECIE) {
      return watch(activeSubSpecieIconIdProvider);
    }
  }

  void _onPressed(BuildContext context) {
    context.read(dropDownValueProvider).value = null;
    if (_specieModel.specieValueType == SpecieValueType.SPECIETYPE) {
      context
          .read(activeSpecieTypeIconIdProvider.notifier)
          .setActiveId(_specieModel);
      context.read(activeSubSpecieIconIdProvider.notifier).resetState();
    } else if (_specieModel.specieValueType == SpecieValueType.SUBSPECIE) {
      if (context.read(activeSpecieTypeIconIdProvider.notifier).currentState !=
          null) {
        context
            .read(activeSubSpecieIconIdProvider.notifier)
            .setActiveId(_specieModel);
      }
    }
  }

  bool _isIconActive(SpecieModel? specieModel) {
    if (specieModel != null && specieModel == _specieModel) {
      return true;
    } else {
      return false;
    }
  }

  BoxBorder _getBorder(SpecieModel? specieModel, BuildContext context) {
    if (_isIconActive(specieModel)) {
      return Border.all(
        width: ScreenConstraintService(context).getConvertedWidth(3),
        color: AppColors.color9,
      );
    } else {
      return Border.all(
        width: ScreenConstraintService(context).getConvertedWidth(3),
        color: Colors.transparent,
      );
    }
  }

  Color _getTextColor(SpecieModel? specieModel, BuildContext context) {
    if (_isIconActive(specieModel)) {
      return AppColors.color7;
    } else {
      return AppColors.color8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(builder: (context, watch, _) {
        final SpecieModel? watchProvider = _getProvider(watch);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: ScreenConstraintService(context).minWidth * 5.3,
              height: ScreenConstraintService(context).minHeight * 3,
              decoration: BoxDecoration(
                border: _getBorder(watchProvider, context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _onPressed(context);
                  },
                  icon: Image.asset(
                    _specieModel.localImageAsset,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Container(
              width: ScreenConstraintService(context).minWidth * 8,
              height: ScreenConstraintService(context).minHeight * 1.2,
              alignment: Alignment.center,
              child: Text(
                _specieModel.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                  fontSize: ScreenConstraintService(context).minHeight * 0.8,
                  color: _getTextColor(watchProvider, context),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
