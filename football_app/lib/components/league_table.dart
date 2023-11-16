import 'package:flutter/material.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/views/team_detail.dart';

class LeagueTable extends StatelessWidget {
  final List<TeamStanding> standings;
  const LeagueTable(this.standings, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
      child: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: standings
              .map((team) => _renderLeagueEntry(context, team))
              .toList(),
        ),
      )),
    );
  }

  Widget _renderLeagueEntry(BuildContext context, TeamStanding team) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TeamDetail(team.teamID, team.teamName, team.logoUrl)))
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.white,
          width: .5,
        ))),
        height: 40,
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _renderRank(context, team.rank),
            _renderLogo(context, team.logoUrl),
            _renderName(context, team.teamName),
            _renderPoints(context, team.points),
            _renderForm(context, team.form)
          ],
        ),
      ),
    );
  }

  Widget _renderPoints(BuildContext context, int points) {
    return SizedBox(
        width: 30,
        child: Text(
          points.toString(),
          textAlign: TextAlign.start,
        ));
  }

  Widget _renderName(BuildContext context, String teamName) {
    return SizedBox(
        width: 90,
        child: Text(
          teamName,
          textAlign: TextAlign.start,
        ));
  }

  Widget _renderLogo(BuildContext context, String logoUrl) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      constraints: const BoxConstraints.tightFor(width: 15, height: 15),
      child: Hero(
        tag: logoUrl,
        child: Image.network(
          logoUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _renderRank(BuildContext context, int rank) {
    return SizedBox(
        width: 20,
        child: Text(
          rank.toString(),
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ));
  }

  Widget _renderForm(BuildContext context, String form) {
    return SizedBox(
      width: 100,
      child: Row(
        children: form
            .split('')
            .reversed
            .map((c) => Container(
                  width: 15,
                  margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                  decoration: BoxDecoration(
                      color: (c == "D")
                          ? Colors.blue.shade600
                          : (c == "W")
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    c,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
