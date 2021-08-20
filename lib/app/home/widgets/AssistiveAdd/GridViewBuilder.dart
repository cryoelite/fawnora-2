import 'package:auto_size_text/auto_size_text.dart';
import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GridViewBuilder extends StatelessWidget {
  final List<SpecieModel> items;
  final _scrollController = ScrollController();
  GridViewBuilder(this.items, {Key? key}) : super(key: key);

  String _formatEnum(String enumVal) {
    final result = enumVal.toLowerCase();
    final index = result.indexOf('.') + 1;
    var convResult = result.replaceRange(0, index, '');
    convResult = convResult.trim();

    convResult = convResult.replaceFirst(
        convResult.characters.first, convResult.characters.first.toUpperCase());
    final latterString = convResult.indexOf('_');
    if (latterString != -1) {
      convResult = convResult.substring(0, latterString);
    }
    return convResult;
  }

  Widget _getItem(
      BuildContext context, int index, SpecieModel? currentSelection) {
    final item = items[index];
    final stateModel = context.read(selectionStatusProvider.notifier);
    final isCurrent = stateModel.currentState == item;
    final isSelectectionActive = currentSelection != null;
    final elem = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.color7,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      ),
      onPressed: () {
        if (isCurrent) {
          stateModel.newState = null;
          _scrollController.animateTo(0,
              duration: Duration(milliseconds: 150), curve: Curves.easeOut);
        } else {
          
          stateModel.newState = item;
          final _height = (ScreenConstraintService(context).minHeight * 20) +
              (ScreenConstraintService(context).minWidth * 3);
          _scrollController.jumpTo(
            index * _height,
          );
        }
      },
      child: Container(
        color: AppColors.color7,
        width: isSelectectionActive
            ? ScreenConstraintService(context).minWidth * 35
            : ScreenConstraintService(context).minWidth * 17,
        height: isSelectectionActive
            ? ScreenConstraintService(context).minHeight * 20
            : ScreenConstraintService(context).minHeight * 12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            item.imagedata != null
                ? Image.memory(
                    item.imagedata!,
                    height: isSelectectionActive
                        ? ScreenConstraintService(context).minHeight * 14.5
                        : ScreenConstraintService(context).minHeight * 7.5,
                  )
                : Image.asset(
                    item.localImageAsset,
                    height: isSelectectionActive
                        ? ScreenConstraintService(context).minHeight * 14.5
                        : ScreenConstraintService(context).minHeight * 7.5,
                  ),
            Container(
              width: isSelectectionActive
                  ? ScreenConstraintService(context).minWidth * 35
                  : ScreenConstraintService(context).minWidth * 17,
              height: isSelectectionActive
                  ? ScreenConstraintService(context).minHeight * 4.5
                  : ScreenConstraintService(context).minHeight * 4.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenConstraintService(context).minHeight * 1.5,
                    child: AutoSizeText(
                      _formatEnum(item.specieType.toString()),
                      style: TextStyle(
                        color: AppColors.color8,
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        fontSize: ScreenConstraintService(context).minHeight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenConstraintService(context).minHeight * 1.5,
                    child: AutoSizeText(
                      _formatEnum(item.subSpecie.toString()),
                      style: TextStyle(
                        color: AppColors.color8,
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        fontSize: ScreenConstraintService(context).minHeight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenConstraintService(context).minHeight * 1.5,
                    child: AutoSizeText(
                      item.name,
                      style: TextStyle(
                        color: AppColors.color8,
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        fontSize: ScreenConstraintService(context).minHeight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            OverflowBar(
              children: [
                item == currentSelection
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: ScreenConstraintService(context).minHeight * 0.3,
                        ),
                        child: Container(
                          width: ScreenConstraintService(context).minWidth * 18,
                          height:
                              ScreenConstraintService(context).minHeight * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.color9,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );

    return elem;
  }

  SliverGridDelegate _getGridDelegate(
      BuildContext context, SpecieModel? specieModel) {
    if (specieModel == null) {
      return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: ScreenConstraintService(context).minHeight * 13,
        crossAxisSpacing: ScreenConstraintService(context).minWidth * 3,
        mainAxisSpacing: ScreenConstraintService(context).minWidth * 3,
      );
    } else {
      return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: ScreenConstraintService(context).minHeight * 20,
        crossAxisSpacing: ScreenConstraintService(context).minWidth * 3,
        mainAxisSpacing: ScreenConstraintService(context).minWidth * 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenConstraintService(context).minWidth * 2,
        right: ScreenConstraintService(context).minWidth * 2,
      ),
      width: ScreenConstraintService(context).maxWidth,
      height: ScreenConstraintService(context).maxHeight -
          ScreenConstraintService(context).minHeight * 12,
      child: Consumer(
        builder: (context, watch, _) {
          final currentSelection = watch(selectionStatusProvider);
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: _getGridDelegate(context, currentSelection),
            itemCount: items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return _getItem(context, index, currentSelection);
            },
          );
        },
      ),
    );
  }
}
