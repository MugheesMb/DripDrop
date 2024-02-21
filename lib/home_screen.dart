// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:map_water/auth/ui/login_signup_screen.dart';
import 'package:map_water/community_screen.dart';
import 'package:map_water/home.dart';
import 'package:map_water/map_advance.dart';
import 'package:map_water/water_tracker.dart';

import 'donation_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = "homePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final name = FirebaseAuth.instance.currentUser!.displayName;
  int _selectedIndex = 2;

  List<Widget> appBarText = [
    const Text("Activities"),
    const Text("Progress"),
    const Text("Home"),
    const Text("Community"),
    const Text("Donate"),
  ];
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const MapAdvance(),
      const MoodTrackerChartScreen(),
      const HomeScreen(),
      const CommunityScreen(),
      DonateScreen(),
      //const Text("heh")
    ];
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ), //BoxDecoration
              child: Image.asset("assets/dd.png"),
            ),
            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: const Text(' Profile '),
            //   onTap: () {
            //     //Navigator.of(context).pushNamed(ComingSoon.routeName);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.book),
            //   title: const Text(' Why is Climate Important? '),
            //   onTap: () {
            //     //Navigator.of(context).pushNamed(ComingSoon.routeName);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.workspace_premium),
            //   title: const Text(' Achievements '),
            //   onTap: () {
            //     //Navigator.of(context).pushNamed(ComingSoon.routeName);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginSignupScreen(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 02, vertical: 10),
            child: GNav(
              rippleColor: Theme.of(context).primaryColor,
              hoverColor: Theme.of(context).primaryColor,
              gap: 6,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).primaryColor,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.pin_drop_rounded,
                  text: 'Clean Water',
                ),
                GButton(
                  icon: Icons.water_drop,
                  text: 'Saved Water',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'HOME',
                ),
                GButton(
                  icon: Icons.people_alt_outlined,
                  text: 'Social',
                ),
                GButton(
                  icon: Icons.handshake_rounded,
                  text: 'Donate',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                if(index!=0){
                  setState(() {
                  _selectedIndex = index;
                });
                }else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MapAdvance(),));
                }
                 
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          pages[_selectedIndex],
        ]),
      ),
    );
  }
}
