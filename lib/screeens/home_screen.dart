import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:practica_5/provider/test_provider.dart';
import 'package:practica_5/screeens/profile_screen.dart';
import 'package:practica_5/settings/colors_settings.dart';
import 'package:practica_5/settings/global_values.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.navColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.access_alarm_outlined),
          ),
          GestureDetector(
            onTap: () {},
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.asset('assets/game_logo.png'),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          switch (index) {
            case 0:
              return Container(
                child: const Text('Homa page'),
              );
            default:
              return const ProfileScreen();
          }
        },
      ),
      drawer: myDrawer(testProvider),
      // drawer: Drawer(),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.exit_to_app, title: 'Exit'),
        ],
        onTap: (int i) => setState(() {
          index = i;
        }),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        children: [
          FloatingActionButton.small(
              heroTag: "btn1",
              onPressed: () {
                GlobalValues.banThemeDark.value = false;
              },
              child: const Icon(Icons.light_mode)),
          FloatingActionButton.small(
              heroTag: "btn2",
              onPressed: () {
                GlobalValues.banThemeDark.value = true;
              },
              child: const Icon(Icons.dark_mode)),
        ],
      ),
    );
  }

  Widget myDrawer(TestProvider testProvider) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            accountName: Text(testProvider.name),
            accountEmail: Text('20030389@itcelaya.edu.mx'),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/db'),
            title: Text('Movies List'),
            subtitle: Text('Database Mvies'),
            leading: Icon(Icons.movie),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/popularMovies'),
            title: Text('Movies List Popular'),
            subtitle: Text('API'),
            leading: Icon(Icons.movie),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/firebaseMovies'),
            title: Text('Movies with firebase'),
            subtitle: Text('Firebase'),
            leading: Icon(Icons.movie),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
