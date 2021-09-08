import 'package:fuzzy/bitap/bitap.dart';
import 'package:fuzzy/fuzzy.dart';

class StringSimilarityCalculator {
  final String firstString;
  final String secondString;

  StringSimilarityCalculator(this.firstString, this.secondString);

  double get alikeness {
    return _bitapSearch();
  }

  double _bitapSearch() {
    final bitap = Bitap(firstString, options: FuzzyOptions(threshold: 0.8));
    final result = bitap.search(secondString);
    return result.score;
  }
}
