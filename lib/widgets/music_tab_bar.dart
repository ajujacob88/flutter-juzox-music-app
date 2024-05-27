import 'package:flutter/material.dart';

class MusicTabBar extends StatelessWidget implements PreferredSizeWidget {
  const MusicTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      dividerColor: Colors.transparent,
      isScrollable: true,
      // padding: EdgeInsets.only(left: 0),
      indicatorColor: Colors.lightBlueAccent,
      // indicatorSize: TabBarIndicatorSize.label,
      //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
      labelColor: Colors.lightBlueAccent,
      labelStyle: TextStyle(fontSize: 17),
      unselectedLabelColor: Color.fromARGB(159, 255, 255, 255),
      unselectedLabelStyle: TextStyle(fontSize: 15),
      //unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,

      tabAlignment: TabAlignment.start,

      tabs: [
        Tab(text: 'Favorites'),
        Tab(text: 'Songs'),
        Tab(text: 'Playlists'),
        Tab(text: 'Folders'),
        Tab(text: 'Albums'),
        Tab(text: 'Artiists'),
        Tab(text: 'Genres'),
      ],
    );
  }
}
