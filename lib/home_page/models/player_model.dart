class Player {
  final String id;
  final String name;
  int secondsWaiting;

  Player({
    required this.id,
    required this.name,
    this.secondsWaiting = 0,
  });

  Player copyWith({
    String? id,
    String? name,
    int? secondsWaiting,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      secondsWaiting: secondsWaiting ?? this.secondsWaiting,
    );
  }
}
