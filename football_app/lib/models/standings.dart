import 'package:football_app/models/match.dart';

class Standings {
  final int leagueID;
  final int season;
  final List<TeamStanding> standings;

  Standings(this.leagueID, this.season, this.standings);

  Standings.blank()
      : leagueID = 0,
        season = 0,
        standings = [];

  factory Standings.fromJson(Map<String, dynamic> json) {
    final leagueInfo = json['league'];
    Standings toReturn = Standings(leagueInfo['id'], leagueInfo['season'],
        parseStandings(leagueInfo["standings"][0]));
    return toReturn;
  }
}

List<TeamStanding> parseStandings(List<dynamic> standings) {
  List<TeamStanding> l = [];
  for (int i = 0; i < standings.length; i++) {
    l.add(TeamStanding.fromJson(standings[i]));
  }

  return l;
}

class TeamStanding {
  final int teamID;
  final String teamName;
  final String logoUrl;
  final int rank;
  final int points;
  final int goalsDiff;
  final String form;

  TeamStanding(this.teamID, this.teamName, this.logoUrl, this.rank, this.points,
      this.goalsDiff, this.form);

  TeamStanding.blank()
      : teamID = 0,
        teamName = "",
        logoUrl = "",
        rank = 0,
        points = 0,
        goalsDiff = 0,
        form = "";

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
        json["team"]['id'],
        json['team']['name'],
        json['team']["logo"],
        json["rank"],
        json["points"],
        json["goalsDiff"],
        json["form"]);
  }
}
