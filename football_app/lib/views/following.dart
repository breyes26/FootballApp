import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:football_app/app.dart';
import 'package:football_app/app_db.dart';
import 'package:football_app/color_helper.dart';
import 'package:football_app/components/carousel.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/components/default_tab_bar.dart';
import 'package:football_app/endpoints/league_endpoint.dart';
import 'package:football_app/endpoints/player_endpoint.dart';
import 'package:football_app/endpoints/team_endpoint.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/player.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/views/player_detail.dart';
import 'package:football_app/views/team_detail.dart';
import 'package:palette_generator/palette_generator.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> with TickerProviderStateMixin {
  // List<League> leagues = [];
  bool loading = false;
  List<Team> teams = [];
  List<Player> players = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    /*List<Map<String, Object?>> leagueEntries =
        await (DatabaseHelper.instance.getEntries("League"));
    List<League> leaguesFromDatabase = [];
    for (int i = 0; i < leagueEntries.length; i++) {
      leaguesFromDatabase.add(await LeagueEndpoint.getLeagueByID(
          leagueEntries[i].values.first.toString()));
    }*/
    loading = true;
    List<Map<String, Object?>> teamEntries =
        await (DatabaseHelper.instance.getEntries("Team"));
    List<Team> teamsFromDatabase = [];
    for (int i = 0; i < teamEntries.length; i++) {
      teamsFromDatabase.add(await TeamEndpoint.getTeamByID(
          teamEntries[i].values.first.toString()));
    }

    List<Map<String, Object?>> playerEntries =
        await (DatabaseHelper.instance.getEntries("Player"));
    List<Player> playersFromDatabase = [];
    for (int i = 0; i < playerEntries.length; i++) {
      playersFromDatabase.add(await PlayerEndpoint.getPlayerByID(
          playerEntries[i].values.first.toString()));
    }

    setState(() {
      teams = teamsFromDatabase;
      players = playersFromDatabase;
    });

    loading = false;
  }

  Future<Color> fetchColor(String tileImage) async {
    PaletteGenerator palette = await ColorHelper.fetchPalette(tileImage);
    Color logoDominantColor = palette.dominantColor!.color;
    return logoDominantColor;
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: DefaultAppBar("Following", AppBar()),
      bottomNavigationBar: DefaultBottomAppBar(),
      body: Column(
        children: (loading)
            ? [_renderProgressBar(context)]
            : [
                DefaultTabBar(tabController, const ["Teams", "Players"]),
                Flexible(
                  child: TabBarView(controller: tabController, children: [
                    (teams.isEmpty)
                        ? _renderProgressBar(context)
                        : GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10,
                            ),
                            physics: const BouncingScrollPhysics(),
                            children: teams
                                .map((e) => GestureDetector(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TeamDetail(e.id, e.name,
                                                        e.logoUrl)))
                                      },
                                      child: _renderCard(e.logoUrl, e.name),
                                    ))
                                .toList(),
                          ),
                    (players.isEmpty)
                        ? Container()
                        : GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 1),
                            physics: const BouncingScrollPhysics(),
                            children: players
                                .map((e) => GestureDetector(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayerDetail(e.id, e.name,
                                                        e.photoUrl)))
                                      },
                                      child: _renderCard(e.photoUrl, e.name),
                                    ))
                                .toList(),
                          ),
                  ]),
                )
              ],
      ),
    );
  }

  Widget _renderCard(String primaryURL, String caption) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              caption,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.network(primaryURL),
          )
        ],
      ),
    );
  }

  Widget _renderProgressBar(BuildContext context) {
    return (loading
        ? const LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          )
        : Container());
  }
}
