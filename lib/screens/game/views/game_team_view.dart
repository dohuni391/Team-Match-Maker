import 'package:flutter/material.dart';
import 'package:team_maker/main.dart';
import 'package:team_maker/screens/game/components/team_view_widget.dart';
import 'package:team_maker/screens/game/views/game_scoreboard_view.dart';
import '../../../models/model.dart';
import '../../../style.dart';

class GameTeamPage extends StatefulWidget {
  const GameTeamPage(
      {Key? key, required this.game, this.isFirstGeneration = false})
      : super(key: key);

  final Game game;
  final bool isFirstGeneration;

  @override
  State<GameTeamPage> createState() => _GameTeamPageState();
}

class _GameTeamPageState extends State<GameTeamPage> {
  @override
  Widget build(BuildContext context) {
    int listIndex = 0;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const Home()), (route) => false);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: widget.isFirstGeneration
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => const Home()),
                        (route) => false);
                  })
              : IconButton(
                  icon: const Icon(Icons.sports_basketball_outlined),
                  onPressed: () {
                    showDialog(
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
                            onPressed: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => const Home()),
                                    (route) => false),
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  }),
          title: const Text('Teams', style: largeTextStyle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                for(int i = 0; i < 5; i++) {
                  widget.game.nextGame();
                }
                setState(() {});
              },
            )
          ],
        ),
        body: TeamView(game: widget.game),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow_rounded),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScoreboardPage(game: widget.game, isFirstGen: widget.isFirstGeneration)));
          },
        ),
      ),
    );
  }
}
