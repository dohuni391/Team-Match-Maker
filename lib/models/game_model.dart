import 'dart:math';

import 'player_model.dart';
import 'team_model.dart';

class Game {

  List<Team> teams = [];
  late int teamSize;
  bool isFirstGame = true;

  Game.startGame(List<Player> allPlayers, this.teamSize, bool isRandom, {mutation = 0}) {
    teams = isRandom ? _createTeams(allPlayers, teamSize) : _createBalancedTeams(allPlayers, teamSize, mutation);
  }

  Game nextGame({int winningTeam = 1}) {
    teams = _nextTeams(teams, teamSize, winningTeam);
    return this;
  }

  List<Team> _createTeams(List<Player> allPlayers, int teamSize){
    List<Team> teams = [];
    int length = allPlayers.length;
    int numOfTeams = (length~/teamSize) + ((length % teamSize == 0) ? 0 : 1);
    allPlayers.shuffle();
    for (int i = 0; i < numOfTeams; i++) {
      int from = i * teamSize;
      int to = min((i * teamSize + teamSize), length);
      teams.add(Team(players: allPlayers.sublist(from, to)));
    }
    return teams;
  }

  List<Team> _createBalancedTeams(List<Player> allPlayers, int teamSize, int mutation){
    List<Team> teams = [];
    int length = allPlayers.length;
    int numOfTeams = ((length~/teamSize)) + ((length % teamSize == 0) ? 0 : 1);

    allPlayers.sort((a, b) => (a.rating*(1+a.getWinRate())).compareTo(b.rating*(1+b.getWinRate())));

    for (int i = 0; i < numOfTeams; i++) {
      teams.add(Team(players: []));
    }

    int teamId = 0;
    for (var i = 0; i < length % teamSize; i++) {
      Player toSit = allPlayers.elementAt(Random().nextInt(teamSize));
      teams.elementAt(numOfTeams-1).add(toSit);
      allPlayers.remove(toSit);
    }

    while(allPlayers.isNotEmpty){
      Player toAdd = allPlayers.elementAt(0);
      teams.elementAt(teamId).add(toAdd);
      allPlayers.remove(toAdd);
      teamId = (teamId < numOfTeams-((length%teamSize)>0 ? 2 : 1)) ? teamId+1 : 0;
    }

    for (int i = 0; i < mutation; i++) {
      Team randomTeam = teams.elementAt(Random().nextInt(numOfTeams));
      Team randomTeam2 = teams.elementAt((Random().nextInt(numOfTeams)));
      Player randomPlayer = randomTeam.getRandomPlayer();
      Player randomPlayer2 = randomTeam2.getRandomPlayer();
      randomTeam.replace(randomPlayer, randomPlayer2);
      randomTeam2.replace(randomPlayer2, randomPlayer);
    }

    return teams;
  }

  List<Team> _nextTeams(List<Team> teams, int teamSize, int winningTeam){
    if(winningTeam == 0){
      var temp = teams[1];
      teams[1] = teams[0];
      teams[0] = temp;
    }
    teams = rotate(teams, 1);
    Team playingTeam = teams.elementAt(1); //Team that is going to play for the first game
    int numNeedPlayers = teamSize - playingTeam.getPlayers().length;

    if(numNeedPlayers == 0) return teams;

    Team sittingTeam = teams.elementAt(2); //Team that is right before the team in the first game
    for (int i = 0; i < numNeedPlayers; i++) {
      Player randomPlayer = sittingTeam.getRandomPlayer();
      sittingTeam.remove(randomPlayer);
      playingTeam.add(randomPlayer);
    }

    return teams;
  }

  List<Team> rotate(List<Team> list, int v) {
    // ignore: unnecessary_null_comparison
    if(list == null || list.isEmpty) return list;

    var i = v % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }
}