import 'dart:async';

import 'package:flutter/material.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/components/detail_hero.dart';
import 'package:football_app/components/default_tab_bar.dart';
import 'package:football_app/endpoints/standings_endpoint.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/components/league_table.dart';
import 'package:football_app/models/match.dart';
import 'package:football_app/endpoints/match_endpoint.dart';
import 'package:football_app/components/matchdays.dart';
import 'package:football_app/color_helper.dart';
import 'package:collection/collection.dart';
import 'package:palette_generator/palette_generator.dart';

class LeagueDetail extends StatefulWidget {
  final League league;
  const LeagueDetail(this.league, {super.key});

  @override
  createState() => _LeagueDetailState();
}

class _LeagueDetailState extends State<LeagueDetail>
    with TickerProviderStateMixin {
  _LeagueDetailState();
  bool loading = false;
  int matchDayOffset = 0;
  Standings standings = Standings.blank();
  List<Match> fixtures = [];
  List<MapEntry<String, List<Match>>> matchDays = [];
  Color logoDominantColor = Colors.black;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (mounted) {
      loading = true;
      Standings standingsFromServer =
          await StandingsEndpoint.getStandingsByLeagueID(
              widget.league.id.toString());
      List<Match> fixturesFromServer =
          await MatchEndpoint.getMatchesCurrSeason(widget.league.id.toString());
      List<MapEntry<String, List<Match>>> matchDaysFromServer = groupBy(
              fixturesFromServer,
              (match) => match.fixture.date.substring(0, 10))
          .entries
          .sortedBy((element) => element.key)
          .toList();

      PaletteGenerator palette =
          await ColorHelper.fetchPalette(widget.league.logoUrl);
      logoDominantColor = palette.dominantColor!.color;

      DateTime rightNow = DateTime.now();
      Duration minDiff = Duration(days: 365);
      int closetMatchday = 0;
      for (int i = 0; i < matchDaysFromServer.length; i++) {
        Duration currDiff =
            rightNow.difference(DateTime.parse(matchDaysFromServer[i].key));
        if (currDiff < minDiff && !currDiff.isNegative) {
          minDiff = currDiff;
          closetMatchday = i;
        }
      }

      setState(() {
        standings = standingsFromServer;
        fixtures = fixturesFromServer;
        matchDays = matchDaysFromServer;
        matchDayOffset = closetMatchday;
      });
    }
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar("", AppBar()),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DetailHero(widget.league.logoUrl, widget.league.name,
              widget.league.country.name, "League", widget.league.id),
          DefaultTabBar(tabController, const ["Table", "Fixtures"]),
          Flexible(
            child: TabBarView(controller: tabController, children: [
              (standings.standings.isNotEmpty)
                  ? RefreshIndicator(
                      color: Colors.black,
                      onRefresh: loadData,
                      child: LeagueTable(standings.standings))
                  : Container(),
              (fixtures.isNotEmpty)
                  ? Matchdays(matchDays, matchDayOffset, logoDominantColor,
                      ColorHelper.getFontColorForBackground(logoDominantColor))
                  : Container()
            ]),
          )
        ],
      ),
    );
  }
}
