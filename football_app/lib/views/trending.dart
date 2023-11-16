import 'package:flutter/material.dart';
import 'package:football_app/app_db.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/endpoints/league_endpoint.dart';
import 'package:football_app/endpoints/player_endpoint.dart';
import 'package:football_app/models/player.dart';
import 'package:football_app/components/carousel.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';

import 'package:football_app/models/team.dart';
import 'package:football_app/endpoints/team_endpoint.dart';

import 'package:intl/intl.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  createState() => _Trending();
}

class _Trending extends State<Trending> {
  List<League> trendingLeagues = [];
  List<Player> trendingPlayers = [];
  List<Team> trendingTeams = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar("Trending", AppBar()),
      body: (loading)
          ? _renderProgressBar(context)
          : Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [carouselTitle("Leagues"), const SeeAll()]),
                    Carousel(trendingLeagues, "League"),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [carouselTitle("Players "), const SeeAll()]),
                    Carousel(trendingPlayers, "Player"),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [carouselTitle("Teams"), const SeeAll()]),
                    Carousel(trendingTeams, "Team"),
                  ]),
            ]),
      bottomNavigationBar: DefaultBottomAppBar(),
    );
  }

  Container carouselTitle(String title) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: Text(title,
            style: const TextStyle(
                fontFamily: 'Montserrat', fontSize: 20, color: Colors.black)));
  }

  Future<void> loadData() async {
    if (mounted) {
      loading = true;

      List<League> leagues = await LeagueEndpoint.getPopularLeagues();
      List<Player> players = await PlayerEndpoint.getPopularPlayers();
      List<Team> teams = await TeamEndpoint.getPopularTeams();

      setState(() {
        trendingTeams = teams;
        trendingLeagues = leagues;
        trendingPlayers = players;
      });

      loading = false;
    }
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

class SeeAll extends StatelessWidget {
  const SeeAll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      alignment: Alignment.centerRight,
      child: Text(
        "See All",
        style: TextStyle(color: Colors.blue.shade400),
      ),
    );
  }
}
