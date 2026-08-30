class Player {

  final String username;
  late final int wins;
  late final int loses;
  late final int draws;

  Player({
    required this.username,
    this.wins = 0,
    this.draws = 0,
    this.loses = 0,
  });

}