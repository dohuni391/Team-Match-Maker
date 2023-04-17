import 'package:flutter/material.dart';
import 'package:team_maker/style.dart';
import 'package:team_maker/models/player_model.dart';

class PlayerListItem extends StatefulWidget {
  PlayerListItem({Key? key, required this.player, this.trailling, this.isSelected = false, this.onTap, this.onLongPress}) : super(key: key);

  final Player player;
  final Widget? trailling;
  final bool isSelected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  State<PlayerListItem> createState() => _PlayerListItemState();
}

class _PlayerListItemState extends State<PlayerListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.isSelected ? backgroundColor : primaryLightColor,
        foregroundColor: widget.isSelected ? backgroundColor : primaryDarkColor,
        child: Text(widget.player.name[0], style: mediumTitleTextStyle),
      ),
      title: Text(widget.player.name, style: mediumTextStyle),
      tileColor: widget.isSelected ? primaryLightColor : backgroundColor,
      trailing: widget.trailling,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }
}
