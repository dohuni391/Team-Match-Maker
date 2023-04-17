import 'package:flutter/material.dart';
import 'package:team_maker/screens/game/views/game_team_view.dart';
import '../../../database/player_db_helper.dart';
import '../../../models/game_model.dart';
import '../../../models/player_model.dart';
import '../../../style.dart';
import '../../components/components.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentStep = 0;

  final List<Player> _allPlayers = [];
  List<Player> selectedPlayers = [];
  double numOfPlayersInTeam = 5;
  double randomnessValue = 1;
  String randomness = 'Slightly Balanced';
  double gameScore = 11;

  List<int> _searchIndexList = [];
  final focusNode = FocusNode();
  bool selectAll = true;

  @override
  void initState() {
    setState(() {
      PlayerDBHelper.getAllPlayers().then((value) {
        if (value != null) {
          for (var item in value) {
            _allPlayers.add(item);
          }}
      });
    });
    super.initState();
  }

  Widget _configurationForm() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          CustomSlider(
            name: 'Number of Players in Team',
            min: 2,
            max: 5,
            divisions: 3,
            value: numOfPlayersInTeam,
            showValue: true,
            displayValue: numOfPlayersInTeam.round().toString(),
            onChanged: (newValue) {
              numOfPlayersInTeam = newValue;
              setState(() {});
            },
          ),
          const Padding(padding: EdgeInsets.only(bottom: 24)),
          CustomSlider(
            name: 'Randomness',
            min: 0,
            max: 2,
            divisions: 2,
            value: randomnessValue,
            showValue: true,
            displayValue: randomness,
            onChanged: (newValue) {
              setState(() {
                randomnessValue = newValue;
                if (newValue == 0) {
                  randomness = 'Complete Random';
                } else if (newValue == 1) {
                  randomness = 'Slightly Balanced';
                } else {
                  randomness = 'Balanced';
                }
              });
            },
          ),
          // const Padding(padding: EdgeInsets.only(bottom: 24)),
          // Row(
          //   children: [
          //     const Text('Consider Player Position', style: smallTextStyle),
          //     const Padding(padding: EdgeInsets.only(right: 20)),
          //     Switch(value: false, onChanged: (newValue) {})
          //   ],
          // ),
          // const Padding(padding: EdgeInsets.only(bottom: 24)),
          // CustomSlider(
          //   name: 'Game Score',
          //   min: 5,
          //   max: 15,
          //   divisions: 10,
          //   value: gameScore,
          //   showValue: true,
          //   displayValue: gameScore.round().toString(),
          //   onChanged: (newValue) {
          //     setState(() {
          //       gameScore = newValue;
          //     });
          //   },
          // ),
          const Padding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      style: mediumTextStyle,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: mediumTextStyle,
          prefixIcon: const Icon(Icons.search, color: iconColor),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: selectAll ? const Icon(Icons.check_box_outline_blank) : const Icon(Icons.check_box),
              onPressed: () {
                selectAll = !selectAll;
                if (selectAll){
                  for (Player player in _allPlayers){
                    if(selectedPlayers.contains(player)){
                      selectedPlayers.remove(player);
                    }
                  }
                } else {
                  for (Player player in _allPlayers){
                    if(!selectedPlayers.contains(player)){
                      selectedPlayers.add(player);
                    }
                  }
                }
                setState(() {});
              },
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none),
          fillColor: const Color(0xFFEFF1F8),
          filled: true),
      focusNode: focusNode,
      onChanged: (newValue) async {
        _searchIndexList = [];
        for (int i = 0; i < _allPlayers.length; i++) {
          if (_allPlayers
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

  Widget _selectPlayerForm() {
    return Column(
      children: [
        _searchTextField(),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        SizedBox(
            height: 350,
            child: _allPlayers.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      if(_searchIndexList.isNotEmpty) index = _searchIndexList[index];
                      return PlayerListItem(
                          player: _allPlayers[index],
                          trailling: Icon(selectedPlayers.contains(_allPlayers[index]) ? Icons.check_box : Icons.check_box_outline_blank),
                          onTap: () {
                            if(selectedPlayers.contains(_allPlayers[index])){
                              selectedPlayers.remove(_allPlayers[index]);
                            } else {
                              selectedPlayers.add(_allPlayers[index]);
                            }
                            setState(() {});
                          });
                    },
                    itemCount: _searchIndexList.isNotEmpty ? _searchIndexList.length : _allPlayers.length,
                  )
                : Center(
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
                  )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
            title: const Text('Game', style: largeTextStyle),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: CustomStepper(
                  currentStep: _currentStep,
                  steps: [
                    Step(
                      title: const Text('Generate New Game',
                          style: largeTextStyle),
                      content: _configurationForm(),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.editing,
                    ),
                    Step(
                        title:
                            const Text('Select Players', style: largeTextStyle),
                        content: _selectPlayerForm(),
                        isActive: _currentStep >= 1,
                        state: _currentStep == 1
                            ? StepState.editing
                            : StepState.disabled)
                  ],
                  controlsBuilder: (context, details) {
                    return Row(
                      children: <Widget>[
                        _currentStep == 0
                            ? Expanded(
                                child: CustomTextButton(
                                  onPressed: details.onStepContinue,
                                  text: 'Continue',
                                ),
                              )
                            : Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextButton(
                                        text: 'Back',
                                        onPressed: details.onStepCancel,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: CustomTextButton(
                                        text: 'Generate',
                                        enabled: selectedPlayers.length/numOfPlayersInTeam.round() >= 2,
                                        onPressed: () {
                                          late Game game;
                                          switch (randomness){
                                            case 'Complete Random':
                                              game = Game.startGame(selectedPlayers, numOfPlayersInTeam.round(), true);
                                              break;
                                            case 'Slightly Balanced':
                                              game = Game.startGame(selectedPlayers, numOfPlayersInTeam.round(), false, mutation: 5);
                                              break;
                                            case 'Balanced':
                                              game = Game.startGame(selectedPlayers, numOfPlayersInTeam.round(), false);
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => GameTeamPage(game: game, isFirstGeneration: true)));
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    );
                  },
                  onStepContinue: () {
                    setState(() {
                      _currentStep++;
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }
}
