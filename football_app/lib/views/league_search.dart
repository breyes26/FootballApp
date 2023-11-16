import 'dart:async';

import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/endpoints/league_endpoint.dart';
import 'package:football_app/models/league.dart';
import 'package:flutter/material.dart';
import 'package:football_app/views/league_detail.dart';

class LeagueSearch extends StatefulWidget {
  const LeagueSearch({super.key});

  @override
  State<LeagueSearch> createState() => _LeagueSearchState();
}

class _LeagueSearchState extends State<LeagueSearch> {
  bool loading = false;
  final fieldText = TextEditingController();
  String searchQuery = "";
  List<League> leagues = [];
  Timer timeHandle = Timer(Duration.zero, () => {});

  @override
  void initState() {
    print("Here");
    super.initState();
  }

  Future<void> loadData() async {
    if (mounted) {
      if (searchQuery.length >= 4) {
        loading = true;
        List<League> leaguesFromServer =
            await LeagueEndpoint.getLeagueBySearch(searchQuery);

        setState(() {
          leagues = leaguesFromServer;
        });
        loading = false;
      } else {
        setState(() {
          leagues = [];
        });
      }
    }
  }

  void textChanged(String val) {
    setState(() {
      searchQuery = val;
    });
    if (timeHandle.isActive) {
      timeHandle.cancel();
    }
    timeHandle = Timer(Duration(seconds: 1), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar("Search Leagues", AppBar()),
      bottomNavigationBar: DefaultBottomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: TextField(
                controller: fieldText,
                onChanged: textChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffixIcon: (searchQuery.isNotEmpty)
                      ? GestureDetector(
                          onTap: () => {
                                fieldText.clear(),
                                setState(() {
                                  searchQuery = "";
                                  leagues = [];
                                })
                              },
                          child: const Icon(Icons.cancel))
                      : const Icon(null),
                  hintText: 'Enter the league name',
                ),
              ),
            ),
            (leagues.isEmpty)
                ? Flexible(child: Container())
                : Flexible(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView(
                        children: leagues
                            .map((league) => _renderLeagueTile(context, league))
                            .toList(),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _renderLeagueTile(BuildContext context, League league) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LeagueDetail(league)))
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: Image.network(league.logoUrl).image))),
            SizedBox(
              width: 150,
              child: Text(
                league.name,
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
