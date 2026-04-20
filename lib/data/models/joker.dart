enum Joker {
  balik(
    id: 'balik',
    label: 'Balik',
    description: 'Gridden en dusuk puanli 3 harfi patlatir.',
    price: 100,
    icon: '🐟',
  ),
  tekerlek(
    id: 'tekerlek',
    label: 'Tekerlek',
    description: 'Gridi tamamen yenisiyle degistirir.',
    price: 200,
    icon: '🎡',
  ),
  lolipopKirici(
    id: 'lolipop',
    label: 'Lolipop Kirici',
    description: 'Rastgele tek bir harfi patlatir.',
    price: 75,
    icon: '🍭',
  ),
  serbestDegistirme(
    id: 'serbest',
    label: 'Serbest Degistirme',
    description: 'Rastgele bir harfi yenisiyle degistirir.',
    price: 125,
    icon: '🔄',
  ),
  harfKaristirma(
    id: 'karistir',
    label: 'Harf Karistirma',
    description: 'Harfleri grid icinde yer degistirir.',
    price: 300,
    icon: '🎲',
  ),
  partiGuclendirici(
    id: 'parti',
    label: 'Parti Guclendiricisi',
    description: 'Sonraki oyunda tum puanlari 2 kat yapar.',
    price: 400,
    icon: '🎉',
  );

  final String id;
  final String label;
  final String description;
  final int price;
  final String icon;

  const Joker({
    required this.id,
    required this.label,
    required this.description,
    required this.price,
    required this.icon,
  });

  static Joker? byId(String id) {
    for (final j in Joker.values) {
      if (j.id == id) return j;
    }
    return null;
  }
}
