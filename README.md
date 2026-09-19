# Word Crush

A Turkish word puzzle game for mobile, built in Flutter. Find words on a letter
grid, clear them, and spend your score on power-ups that reshape the board.

## Gameplay

- Trace words on a letter grid; valid words clear and the grid refills
- Three difficulties — each sets its own grid size and move limit
- Words are validated against a 4,878-word Turkish dictionary bundled with the app
- Score carries over into a market where you buy jokers
- Local scoreboard tracks your best runs

### Jokers

| Joker | Effect | Price |
|---|---|---|
| 🍭 Lolipop Kırıcı | Clears one random letter | 75 |
| 🐟 Balık | Clears the three lowest-scoring letters | 100 |
| 🔄 Serbest Değiştirme | Replaces a random letter with a new one | 125 |
| 🎡 Tekerlek | Replaces the entire grid | 200 |
| 🎲 Harf Karıştırma | Shuffles the letters in place | 300 |
| 🎉 Parti Güçlendiricisi | Doubles all points in the next game | — |

## Turkish letter handling

Turkish breaks the usual uppercase rules: `i` uppercases to `İ`, and `ı`
uppercases to `I`. Dart's built-in `toUpperCase()` gets both wrong, which would
silently corrupt word matching. The game ships its own
[`TurkishCase`](lib/core/utils/turkish_case.dart) utility with an explicit
letter map, and [`turkish_letters.dart`](lib/core/constants/turkish_letters.dart)
defines the alphabet and per-letter point values used for scoring.

## Architecture

MVVM with Provider for state, organised feature-first:

```
lib/
├── core/
│   ├── constants/      # grid sizes, move counts, Turkish alphabet
│   ├── theme/          # colors and theme
│   ├── routes/
│   └── utils/          # Turkish-aware casing
├── data/
│   ├── models/         # Board, Cell, Joker, Difficulty, User, Stats, Inventory
│   ├── repositories/   # user, stats, inventory — persistence boundary
│   └── services/       # board analyzer, word validator
├── features/           # each feature owns its view + viewmodel
│   ├── onboarding/
│   ├── home/
│   ├── game/           # + widgets: board, letter tile, joker bar, word preview
│   ├── scoreboard/
│   └── market/
└── shared/widgets/
```

Views never touch repositories directly — viewmodels sit in between, so game
rules stay testable independently of the widget tree.

## Tech

Flutter · Dart · Provider · shared_preferences · google_fonts · intl · uuid

Fully offline. No backend, no accounts, no network calls — progress persists
locally through `shared_preferences`.

## Running it

```bash
git clone https://github.com/selimdogann/word-crush-game.git
cd word-crush-game
flutter pub get
flutter run
```

Requires the Flutter SDK. Runs on Android and iOS.

## License

MIT — see [LICENSE](LICENSE).
