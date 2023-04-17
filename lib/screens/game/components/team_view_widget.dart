import 'package:flutter/material.dart';

import '../../../models/model.dart';
import '../../../style.dart';
import '../../components/player_list_widget.dart';

class TeamView extends StatefulWidget {
  const TeamView({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {

  Player? toReplace;
  int? toReplaceIndex;
  int? toReplaceTeamIndex;
  Player? replaceTo;

  Widget _listHeader(int teamIndex) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Center(
            child: Text('Team $teamIndex', style: smallTitleTextStyle),
          ),
        ),
        const Divider(thickness: 1, height: 0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PlayerListItem(
              player: widget.game.teams[teamIndex].getPlayers()[index],
              onTap: () {
                Player selected = widget.game.teams[teamIndex].getPlayers()[index];
                if(toReplace == null){
                  toReplace = selected;
                  toReplaceIndex = index;
                  toReplaceTeamIndex = teamIndex;
                } else {
                  replaceTo = selected;

                  widget.game.teams[toReplaceTeamIndex!].getPlayers().remove(toReplace);
                  widget.game.teams[toReplaceTeamIndex!].getPlayers().insert(toReplaceIndex!, selected);

                  widget.game.teams[teamIndex].getPlayers().remove(selected);
                  widget.game.teams[teamIndex].getPlayers().insert(index, toReplace!);

                  toReplace = null;
                  toReplaceIndex = null;
                  toReplaceTeamIndex = null;
                  replaceTo = null;
                }

                setState(() {});
              },
              isSelected: toReplace == widget.game.teams[teamIndex].getPlayers()[index] || replaceTo == widget.game.teams[teamIndex].getPlayers()[index],

            );
          },
          itemCount: widget.game.teams[teamIndex].getPlayers().length,
        ),
        //Delete This Later
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Center(
          child: Text('True Rating: ${widget.game.teams[teamIndex].totalRating()}',
              style: labelTextStyle),
        ), //Delete This Later
        const Padding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int listIndex = 0;
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: (widget.game.teams.length / 2).round(),
      itemBuilder: (context, index) {
        if (index + listIndex + 1 < (widget.game.teams.length)) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _listHeader(index + listIndex)),
              Expanded(child: _listHeader(index + (listIndex++) + 1))
            ],
          );
        } else {
          return Expanded(child: _listHeader(widget.game.teams.length - 1));
        }
      },
    );
  }
}
