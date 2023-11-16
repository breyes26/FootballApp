import 'package:flutter/material.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/endpoints/match_endpoint.dart';
import 'package:intl/intl.dart';
import 'package:football_app/models/match.dart';
import 'package:collection/collection.dart';
import '../components/default_appbar.dart';
import 'package:football_app/components/matchdays.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  List<Match> matches = [];
  bool loading = false;
  List<MapEntry<String, List<Match>>> matchesbyLeague = [];
  bool live = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar("Matches", AppBar()),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
        width: 60,
        height: 30,
        child: FloatingActionButton(
          backgroundColor: (live) ? Colors.grey : Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => {live = !live, loadData()},
          child: (live)
              ? const Text("All")
              : const Text(
                  "LIVE",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
      body: (loading)
          ? _renderProgressBar(context)
          : ListView(
              children: matchesbyLeague
                  .map(
                    (e) => _renderLeagueGames(context, e),
                  )
                  .toList(),
            ),
      bottomNavigationBar: DefaultBottomAppBar(),
    );
  }

  Widget _renderLeagueGames(
    BuildContext context,
    MapEntry<String, List<Match>> matchday,
  ) {
    var matchesLive = matchday.value.where((element) =>
        element.fixture.status.short == "HT" ||
        element.fixture.status.short == "1H" ||
        element.fixture.status.short == "2H");

    return (matchesLive.isEmpty && live)
        ? Container()
        : Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.black),
            child: Column(
                children: [
                      _renderLeagueGamesHeader(context, matchday.key,
                          matchday.value[0].league.logoUrl)
                    ] +
                    matchday.value
                        .map((match) => (!live)
                            ? renderFixture(context, match, Colors.white)
                            : (match.fixture.status.short == "2H" ||
                                    match.fixture.status.short == "1H" ||
                                    match.fixture.status.short == "HT")
                                ? renderFixture(context, match, Colors.white)
                                : Container())
                        .toList()),
          );
  }

  Widget _renderLeagueGamesHeader(
      BuildContext context, String leagueName, String logoUrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            leagueName,
            style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: Image.network(logoUrl).image)),
          )
        ],
      ),
    );
  }

  Future<void> loadData() async {
    if (mounted) {
      loading = true;
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime now = DateTime.now();

      List<Match> matchesFromServer =
          await MatchEndpoint.getMatchesByDateLeague(formatter.format(now));

      List<MapEntry<String, List<Match>>> matchesByLeagueFromServer =
          groupBy(matchesFromServer, (e) => e.league.name).entries.toList();

      matchesbyLeague = matchesByLeagueFromServer;

      setState(() {
        matches = matchesFromServer;
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
