import 'dart:math';

import 'player_model.dart';

class Team{
  List<Player> players;
  Team({required this.players});

  List<Player> getPlayers() => players;

  Player getRandomPlayer() => players.elementAt(Random().nextInt(players.length));

  void add(Player p) => players.add(p);

  void remove(Player p) => players.remove(p);

  void replace(Player cp, Player np){
    if (!(players.contains(cp))) return;
    remove(cp);
    add(np);
  }

  int totalRating(){
    double sum = 0;
    for (Player player in players) {
      sum+=player.rating*(1+player.getWinRate());
    }
    return sum.round();
  }
}