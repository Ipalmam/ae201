import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:ae201/screens/hangar/home_screen.dart';
import 'package:ae201/screens/hangar/versus_screen.dart';
import 'package:ae201/screens/hangar/solo_ops_screen.dart';
import 'package:ae201/screens/hangar/squad_screen.dart';
import 'package:ae201/screens/settings_screen.dart';
import 'package:ae201/widgets/audio_manager.dart';

class StartScreen extends StatefulWidget {
  final String languageCode;
  final Map<String, dynamic> localizedStrings;

  const StartScreen({
    super.key,
    required this.languageCode,
    required this.localizedStrings,
  });

  @override
  State<StartScreen> createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  final List<Color> tabColors = [
    Colors.amber,        // Home
    Colors.redAccent,    // Versus
    Colors.blue,         // Solo Ops
    Colors.green,        // Squad
    Colors.deepPurple,   // Settings
  ];

  @override
  void initState() {
    super.initState();
    AudioManager().playBackgroundLoop();

    _pages = [
      HomeScreen(),
      VersusScreen(),
      SoloOpsScreen(),
      SquadScreen(),
      SettingsScreen(localizedStrings: widget.localizedStrings),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
            _controller.index = index;
          });
        },
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        kIconSize: 24.0,
        kBottomRadius: 10.0,
        showLabel: true,
        color: tabColors[_selectedIndex], // ✅ Synced with selected icon
        notchBottomBarController: _controller,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home, color: Colors.black),
            activeItem: Icon(Icons.dashboard, color: tabColors[0]),
            itemLabel: widget.localizedStrings['menu']['home'] ?? 'Home',
          ),
          BottomBarItem(
            inActiveItem: Image.asset('assets/icons/swords.png', color: Colors.black),
            activeItem: Image.asset('assets/icons/sword_rose.png', color: tabColors[1]),
            itemLabel: widget.localizedStrings['menu']['versus'] ?? 'Versus',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.black),
            activeItem: Image.asset('assets/icons/person_raised_hand.png', color: tabColors[2]),
            itemLabel: widget.localizedStrings['menu']['soloOps'] ?? 'Solo Ops',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.military_tech, color: Colors.black),
            activeItem: Icon(Icons.pentagon, color: tabColors[3]),
            itemLabel: widget.localizedStrings['menu']['squad'] ?? 'Squad',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.settings, color: Colors.black),
            activeItem: Icon(Icons.build, color: tabColors[4]),
            itemLabel: widget.localizedStrings['menu']['settings'] ?? 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _controller.index = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}