class Player {

  final String username;
   final int wins;
   final int loses;
   final int draws;

  Player({
    required this.username,
    this.wins = 0,
    this.draws = 0,
    this.loses = 0,
  });

}