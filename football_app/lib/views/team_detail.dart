import 'dart:async';
import 'package:flutter/material.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/endpoints/squad_endpoints.dart';
import 'package:football_app/endpoints/team_endpoint.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/components/default_tab_bar.dart';
import "package:football_app/components/detail_hero.dart";
import 'package:football_app/models/squad.dart';
import 'package:football_app/views/player_detail.dart';
import 'package:collection/collection.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:football_app/color_helper.dart';

class TeamDetail extends StatefulWidget {
  final int teamID;
  final String teamName;
  final String logoURL;
  const TeamDetail(this.teamID, this.teamName, this.logoURL, {super.key});

  @override
  createState() => _TeamDetailState();
}

class _TeamDetailState extends State<TeamDetail> with TickerProviderStateMixin {
  _TeamDetailState();
  bool loading = false;
  Team team = Team.blank();
  Squad squad = Squad.blank();
  List<MapEntry<String, List<SquadPlayer>>> playersByPosition = [];
  Color tileColor = Colors.black;
  Color tileFontColor = Colors.black;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (mounted) {
      loading = true;
      Team teamFromServer =
          await TeamEndpoint.getTeamByID(widget.teamID.toString());
      Squad squadFromServer =
          await SquadEndpoint.getSquadByTeamID(teamFromServer.id.toString());

      List<MapEntry<String, List<SquadPlayer>>> playersByPositionFromServer =
          groupBy(squadFromServer.squad, (e) => e.position).entries.toList();

      PaletteGenerator palette = await ColorHelper.fetchPalette(widget.logoURL);
      tileColor = palette.dominantColor!.color;
      tileFontColor = ColorHelper.getFontColorForBackground(tileFontColor);

      setState(() {
        squad = squadFromServer;
        team = teamFromServer;
        playersByPosition = playersByPositionFromServer;
      });

      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar("", AppBar()),
      body: Column(children: [
        DetailHero(widget.logoURL, widget.teamName, team.venue.city, "Team",
            widget.teamID),
        DefaultTabBar(tabController, const ["Stats", "Players"]),
        Flexible(
            child: TabBarView(
          controller: tabController,
          children: [
            Container(),
            (squad.squad.isNotEmpty)
                ? ListView(
                    children: playersByPosition
                        .map((e) =>
                            _renderSquadPosition(context, e.key, e.value))
                        .toList(),
                  )
                : Container()
          ],
        ))
      ]),
    );
  }

  Widget _renderSquadPosition(
      BuildContext context, String position, List<SquadPlayer> players) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: tileColor),
        margin: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_renderPostionTitle(position)] +
                players.map((p) => _renderSquadPlayer(p)).toList()));
  }

  Widget _renderPostionTitle(String position) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Text(
        "${position}s",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
          color: tileFontColor,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _renderSquadPlayer(SquadPlayer player) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PlayerDetail(player.id, player.name, player.photoUrl)))
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: Image.network(player.photoUrl).image)),
              margin: const EdgeInsets.fromLTRB(8, 0, 10, 0),
              width: 30,
              height: 30,
            ),
            Container(
              width: 100,
              alignment: Alignment.centerLeft,
              child: Text(
                player.name,
                style: TextStyle(color: tileFontColor),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                width: 20,
                child: Text(
                  player.number.toString(),
                  style: TextStyle(color: tileFontColor),
                ))
          ],
        ),
      ),
    );
  }
}
