import 'package:flutter/material.dart';
import 'package:team_maker/screens/screens.dart';
import 'package:team_maker/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        iconTheme: const IconThemeData(
          color: iconVariantColor
        ),
        appBarTheme: const AppBarTheme(
          color: backgroundColor
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: backgroundColor,
          indicatorColor: primaryLightColor,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: primaryColor,
          overlayColor: primaryLightColor.withOpacity(0.2),
          activeTrackColor: primaryColor,
          inactiveTrackColor: backgroundVariantColor
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryLightColor,
          foregroundColor: primaryDarkColor
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(28.0),
                topLeft: Radius.circular(28.0),
              )
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            minimumSize: const Size.fromHeight(40),
            onPrimary: onPrimaryColor
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: primaryColor,
          linearTrackColor: backgroundVariantColor,
          circularTrackColor: backgroundVariantColor
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) => primaryColor),
          trackColor: MaterialStateProperty.resolveWith((states){
            if(states.contains(MaterialState.selected)){
              return primaryLightColor;
            }
          }),
        ),

      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const PlayerPage(),
    const GamePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (int newIndex) {_onItemTapped(newIndex);},
          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(Icons.people_outline_outlined, color: iconColor),
                icon: Icon(Icons.people_outline_outlined, color: iconVariantColor),
                label: 'Player'
            ),
            NavigationDestination(
                selectedIcon: Icon(Icons.sports_basketball_outlined, color: iconColor),
                icon: Icon(Icons.sports_basketball_outlined, color: iconVariantColor),
                label: 'Game'
            ),
          ],
        ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

