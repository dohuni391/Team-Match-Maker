import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:team_maker/models/model.dart';
import 'package:team_maker/database/player_db_helper.dart';
import 'package:team_maker/screens/player/views/player_profile_view.dart';
import '../../components/components.dart';
import '../components/components.dart';
import 'package:team_maker/style.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _searchBoolean = false;
  List<int> _searchIndexList = [];

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      style: mediumTextStyle,
      textInputAction:
          TextInputAction.search, //Specify the action button on the keyboard
      decoration: const InputDecoration(
          //Style of TextField
          hintText: 'Search', //Text that is displayed when nothing is entered.
          hintStyle: mediumTextStyle),
      onChanged: (newValue) async {
        _searchIndexList = [];
        var list = await PlayerDBHelper.getAllPlayers();
        for (int i = 0; i < list!.length; i++) {
          if (list
              .elementAt(i)
              .name
              .toLowerCase()
              .contains(newValue.toLowerCase())) {
            _searchIndexList.add(i);
          }
        }
        setState(() {});
      },
    );
  }

  Widget _searchListView() {
    //add
    return FutureBuilder<List<Player>?>(
        future: PlayerDBHelper.getAllPlayers(),
        builder: (context, AsyncSnapshot<List<Player>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  index = _searchIndexList[index];
                  return PlayerListItem(
                    player: snapshot.data![index],
                  );
                },
                itemCount: _searchIndexList.length);
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.person_off, size: 80, color: Colors.black12),
                  Text("No Player Yet", style: TextStyle(color: Colors.black45))
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !_searchBoolean
              ? const Text('Players', style: largeTextStyle)
              : _searchTextField(),
          centerTitle: true,
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                          _searchIndexList = [];
                        });
                      })
                ]
              : [
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                        });
                      })
                ]),
      body: _searchBoolean
          ? _searchListView()
          : FutureBuilder<List<Player>?>(
              future: PlayerDBHelper.getAllPlayers(),
              builder: (context, AsyncSnapshot<List<Player>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemBuilder: (context, index) => PlayerListItem(
                            player: snapshot.data![index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerProfilePage(
                                          player: snapshot.data![index]))).then(
                                  (value) {
                                setState(() {});
                              });
                            },
                          ),
                      itemCount: snapshot.data!.length);
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.person_off,
                            size: 100, color: Colors.black12),
                        Text("No Player Yet",
                            style: TextStyle(color: Colors.black45))
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.person_add_alt_1),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                enableDrag: false,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: PlayerAddBottomSheet(
                      onSave: (name, rating) async {
                        await PlayerDBHelper.addPlayer(Player(
                            name: name,
                            rating: rating.round(),
                            gamesWon: 0,
                            gamesPlayed: 0));
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  );
                });
          }),
    );
  }
}
