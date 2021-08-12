import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/SpecieValueTypeEnum.dart';

class SpecieModel {
  final String name;
  final String? subSpecie;
  final String localImageAsset;
  final SpecieValueType specieValueType;
  final int specieId;
  final SpecieType specieType;
  SpecieModel(
    this.name,
    this.localImageAsset,
    this.specieValueType,
    this.specieId, {
    required this.specieType,
    this.subSpecie,
  });

  @override
  bool operator ==(Object other) =>
      other is SpecieModel && other.specieId == specieId;

  @override
  int get hashCode => specieId.hashCode;
}
