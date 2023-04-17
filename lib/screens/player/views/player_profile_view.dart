import 'package:flutter/material.dart';
import 'package:team_maker/database/player_db_helper.dart';
import 'package:team_maker/screens/components/components.dart';
import 'package:team_maker/style.dart';
import '../../../models/player_model.dart';
import '../components/player_add_sheet.dart';

class PlayerProfilePage extends StatefulWidget {
  const PlayerProfilePage({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  State<PlayerProfilePage> createState() => _PlayerProfilePageState();
}

class _PlayerProfilePageState extends State<PlayerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Text('ID: ${widget.player.id}', style: largeTextStyle),
                Text('Games Played: ${widget.player.gamesPlayed}',
                    style: largeTextStyle),
                widget.player.gamesPlayed == 0
                    ? const Text('No Games Played', style: largeTextStyle)
                    : Text('Win Rate: ${(widget.player.getWinRate() * 100).round()}%',
                        style: largeTextStyle),
                Text('Rating: ${widget.player.rating}', style: largeTextStyle),
                Padding(padding: EdgeInsets.only(bottom: 16)),
                Text('I am so lazy to make this pretty')
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: 'Edit',
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          enableDrag: false,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: PlayerAddBottomSheet(
                                initName: widget.player.name,
                                initRating: widget.player.rating,
                                onSave: (name, rating) async {
                                  widget.player.name = name;
                                  widget.player.rating = rating.round();
                                  await PlayerDBHelper.updatePlayer(widget.player);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                              ),
                            );
                          });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextButton(
                    text: 'Delete',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this player?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      PlayerDBHelper.deletePlayer(
                                          widget.player);
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
