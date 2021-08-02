import 'package:hive/hive.dart';

part 'LocaleTypeEnum.g.dart';

@HiveType(typeId: 1)
enum LocaleType {
  @HiveField(0)
  ENGLISH,
  @HiveField(1)
  HINDI,
}
