import 'package:flutter/material.dart';
import 'package:football_app/views/following.dart';
import 'package:football_app/views/league_search.dart';
import 'package:football_app/views/matches.dart';
import 'package:football_app/views/trending.dart';

class DefaultBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Color backgroundColor = Colors.grey.shade200;
  final double elevation = 0;
  bool toggled = false;
  DefaultBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade50,
      elevation: 0,
      child: Row(
        children: [
          IconButton(
              onPressed: () => {
                    toggled = !toggled,
                    (toggled)
                        ? showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            builder: ((BuildContext context) => SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView(
                                    children: [
                                      _renderBottomsheetTile(
                                          "Matches",
                                          "assets/images/matches.png",
                                          const Icon(null),
                                          const Matches(),
                                          context),
                                      _renderBottomsheetTile(
                                          "Following",
                                          "",
                                          const Icon(
                                              Icons.star_border_outlined),
                                          const Following(),
                                          context),
                                      _renderBottomsheetTile(
                                          "Trending",
                                          "",
                                          const Icon(
                                              Icons.trending_up_outlined),
                                          const Trending(),
                                          context),
                                      _renderBottomsheetTile(
                                          "Search",
                                          "",
                                          const Icon(Icons.search),
                                          const LeagueSearch(),
                                          context),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          height: 40,
                                          margin: const EdgeInsets.fromLTRB(
                                              12, 0, 0, 0),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.menu),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )))
                        : Container()
                  },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ))
        ],
      ),
    );
  }

  Widget _renderBottomsheetTile(String text, String assetUrl, Icon icon,
      Widget pushto, BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => pushto),
            ModalRoute.withName("/"))
      },
      child: Container(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 60,
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text(text)),
            SizedBox(
                height: 20,
                width: 20,
                child: (assetUrl.isNotEmpty) ? Image.asset(assetUrl) : icon)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
