import '../../core/constants/app_constants.dart';

enum Difficulty {
  easy('easy'),
  medium('medium'),
  hard('hard');

  final String key;
  const Difficulty(this.key);

  int get gridSize => AppConstants.gridSizes[key]!;
  int get moveCount => AppConstants.moveCounts[key]!;
  String get label => AppConstants.difficultyLabels[key]!;

  static Difficulty fromKey(String key) =>
      Difficulty.values.firstWhere((d) => d.key == key,
          orElse: () => Difficulty.medium);
}
