/* import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/services/FirebaseStorageService.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Statter extends ConsumerWidget {
  const Statter({Key? key}) : super(key: key);

  Future<void> doStuff(BuildContext context) async {
    final imageNames =
        await context.read(firebaseStorageProvider).getImageNames();
    final species = await context
        .read(localStorageProvider)
        .retrieveAllSubspecieData(LocaleType.ENGLISH);
    final specieNameList = <String>[];

    for (final entry in species.entries) {
      for (final subEntry in entry.value.entries) {
        final listData = subEntry.value;
        if (listData != null) {
          specieNameList.addAll(listData);
        }
      }
    }

    await context
        .read(firestoreProvider)
        .englishNameImageListFiller(imageNames, specieNameList);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () async {
        await doStuff(context);
      },
      child: Container(
        height: ScreenConstraintService(context).minHeight * 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.color15,
              AppColors.color16,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ScreenConstraintService(context).minWidth * 30,
              height: ScreenConstraintService(context).minHeight * 2,
              padding: EdgeInsets.only(
                left: ScreenConstraintService(context).minWidth * 3,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Statter",
                style: TextStyle(
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenConstraintService(context).minWidth * 2,
                  color: AppColors.color2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */