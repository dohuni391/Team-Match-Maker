import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:team_maker/database/player_db_helper.dart';
import 'package:team_maker/screens/game/components/team_view_widget.dart';
import 'package:team_maker/screens/game/views/game_team_view.dart';
import 'package:team_maker/style.dart';
import '../../../main.dart';
import '../../../models/model.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({Key? key, required this.game, this.isFirstGen = false}) : super(key: key);

  final Game game;
  final bool isFirstGen;

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  int winningTeamIndex = 2;
  bool keepSameTeam = false;

  Widget selectWinner(
      String text, void Function()? onTap, Color color, Color fontColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            style: TextStyle(
                fontSize: 16,
                height: 24 / 16,
                letterSpacing: 0.15,
                color: fontColor,
                fontWeight: FontWeight.w500),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit the game'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const Home()),
        (route) => false),
              child: new Text('Yes'),
            ),
          ],
        ),
        )) ??
        false;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 72),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Which Team', style: largeTitleTextStyle),
                        Text('won the game?', style: largeTextStyle),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.people),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: Text('Teams'),), body: TeamView(game: widget.game),)));
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: selectWinner('HOME TEAM', () {
                      setState(() {
                        if (winningTeamIndex == 0) {
                          winningTeamIndex = 2;
                        } else {
                          winningTeamIndex = 0;
                        }
                      });
                    },
                            winningTeamIndex == 0 ? primaryColor : winningTeamIndex == 2 ? primaryLightColor : primaryLightColor,
                            winningTeamIndex == 0 ? onPrimaryColor : primaryFontColor)
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: selectWinner('AWAY TEAM', () {
                          setState(() {
                            if (winningTeamIndex == 1) {
                              winningTeamIndex = 2;
                            } else {
                              winningTeamIndex = 1;
                            }
                          });
                        },
                            winningTeamIndex == 1 ? primaryColor : winningTeamIndex == 2 ? primaryLightColor : primaryLightColor,
                            winningTeamIndex == 1 ? onPrimaryColor : primaryFontColor)
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text('Keep Same Teams', style: mediumTextStyle),
                    const Padding(padding: EdgeInsets.only(right: 20)),
                    Switch(value: keepSameTeam, onChanged: (newValue) {
                      setState(() {
                        keepSameTeam = newValue;
                      });
                    })
                  ],
                ),
              ),
            ],
          ),
        floatingActionButton: Visibility(
          visible: winningTeamIndex != 2,
          child: FloatingActionButton(
            child: const Icon(Icons.play_arrow_rounded),
            onPressed: () async {
              for(int i = 0; i < 2; i++){
                for(Player player in widget.game.teams[i].getPlayers()){
                  player.gamesPlayed++;
                  if (i == winningTeamIndex) player.gamesWon++;
                  await PlayerDBHelper.updatePlayer(player);
                }
              }
              var nextGame = keepSameTeam ? widget.game : widget.isFirstGen ? widget.game.nextGame(winningTeam: winningTeamIndex) : widget.game.nextGame();
              if(mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => GameTeamPage(game: nextGame)));
              setState(() {

              });
            },
          ),
        ),
      ),
    );
  }
}
