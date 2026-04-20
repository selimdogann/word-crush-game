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

  const Cell.empty({required this.row, required this.col})
      : letter = '',
        power = CellPower.none;

  int get point => TurkishLetters.pointOf(letter);
  bool get isEmpty => letter.isEmpty;

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
        return 'S';
      case CellPower.columnClear:
        return 'D';
      case CellPower.areaBlast:
        return 'A';
      case CellPower.megaBlast:
        return 'M';
      case CellPower.none:
        return '';
    }
  }

  String get label {
    switch (this) {
      case CellPower.rowClear:
        return 'Satir Temizleyici';
      case CellPower.columnClear:
        return 'Sutun Temizleyici';
      case CellPower.areaBlast:
        return 'Alan Patlatici';
      case CellPower.megaBlast:
        return 'Mega Patlatici';
      case CellPower.none:
        return '';
    }
  }
}
