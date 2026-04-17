import '../../core/constants/turkish_letters.dart';

class Cell {
  final int row;
  final int col;
  final String letter;
  final CellPower power;

  const Cell({
    required this.row,
    required this.col,
    required this.letter,
    this.power = CellPower.none,
  });

  int get point => TurkishLetters.pointOf(letter);

  Cell copyWith({int? row, int? col, String? letter, CellPower? power}) => Cell(
        row: row ?? this.row,
        col: col ?? this.col,
        letter: letter ?? this.letter,
        power: power ?? this.power,
      );

  String get id => '$row-$col';

  @override
  bool operator ==(Object other) =>
      other is Cell && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);
}

enum CellPower {
  none,
  rowClear,
  columnClear,
  areaBlast,
  megaBlast;

  static CellPower fromWordLength(int length) {
    if (length >= 7) return CellPower.megaBlast;
    if (length == 6) return CellPower.columnClear;
    if (length == 5) return CellPower.areaBlast;
    if (length == 4) return CellPower.rowClear;
    return CellPower.none;
  }

  String get icon {
    switch (this) {
      case CellPower.rowClear:
        return '⇆';
      case CellPower.columnClear:
        return '⇅';
      case CellPower.areaBlast:
        return '✹';
      case CellPower.megaBlast:
        return '✪';
      case CellPower.none:
        return '';
    }
  }
}
