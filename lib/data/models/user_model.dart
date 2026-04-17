class UserModel {
  final String username;
  final int coins;

  const UserModel({required this.username, required this.coins});

  UserModel copyWith({String? username, int? coins}) => UserModel(
        username: username ?? this.username,
        coins: coins ?? this.coins,
      );
}
