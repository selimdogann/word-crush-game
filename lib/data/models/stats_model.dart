import 'dart:convert';

class StatsModel {
  final int totalGames;
  final int totalScore;
  final int highScore;
  final int totalWords;
  final String longestWord;
  final int totalDurationSeconds;

  const StatsModel({
    this.totalGames = 0,
    this.totalScore = 0,
    this.highScore = 0,
    this.totalWords = 0,
    this.longestWord = '',
    this.totalDurationSeconds = 0,
  });

  double get averageScore =>
      totalGames == 0 ? 0 : totalScore / totalGames;

  Map<String, dynamic> toJson() => {
        'totalGames': totalGames,
        'totalScore': totalScore,
        'highScore': highScore,
        'totalWords': totalWords,
        'longestWord': longestWord,
        'totalDurationSeconds': totalDurationSeconds,
      };

  factory StatsModel.fromJson(Map<String, dynamic> json) => StatsModel(
        totalGames: json['totalGames'] ?? 0,
        totalScore: json['totalScore'] ?? 0,
        highScore: json['highScore'] ?? 0,
        totalWords: json['totalWords'] ?? 0,
        longestWord: json['longestWord'] ?? '',
        totalDurationSeconds: json['totalDurationSeconds'] ?? 0,
      );

  String encode() => jsonEncode(toJson());
  static StatsModel decode(String raw) =>
      StatsModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  StatsModel mergedWith(GameResult result) => StatsModel(
        totalGames: totalGames + 1,
        totalScore: totalScore + result.score,
        highScore: result.score > highScore ? result.score : highScore,
        totalWords: totalWords + result.wordCount,
        longestWord: result.longestWord.length > longestWord.length
            ? result.longestWord
            : longestWord,
        totalDurationSeconds: totalDurationSeconds + result.durationSeconds,
      );
}

class GameResult {
  final int score;
  final int wordCount;
  final String longestWord;
  final int durationSeconds;
  final String difficultyKey;

  const GameResult({
    required this.score,
    required this.wordCount,
    required this.longestWord,
    required this.durationSeconds,
    required this.difficultyKey,
  });
}
