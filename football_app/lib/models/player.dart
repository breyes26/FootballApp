import 'package:flutter/material.dart';
import 'package:football_app/models/league.dart';

class Player {
  final int id;
  final String name;
  final String photoUrl;
  final PlayerTeam team;
  final String birth;
  final String country;
  final int age;
  final String height;
  final String weight;
  final League league;
  final PlayerStats stats;

  Player(this.id, this.name, this.photoUrl, this.team, this.birth, this.country,
      this.age, this.height, this.weight, this.league, this.stats);

  Player.blank()
      : id = 0,
        name = "",
        photoUrl = "",
        team = PlayerTeam.blank(),
        birth = "",
        country = "",
        age = 0,
        weight = "",
        height = "",
        league = League.blank(),
        stats = PlayerStats.blank();

  factory Player.fromJson(Map<String, dynamic> json) {
    final playerInfo = json['player'];
    final stats = json['statistics'][0];
    final teamInfo = stats['team'];

    return Player(
        playerInfo['id'],
        playerInfo['name'],
        playerInfo['photo'],
        PlayerTeam.fromJson(teamInfo),
        playerInfo["birth"]["date"],
        playerInfo["birth"]["country"],
        playerInfo["age"],
        playerInfo["height"],
        playerInfo["weight"],
        League.fromJson(stats),
        PlayerStats.fromJson(stats));
  }
}

class PlayerTeam {
  final int id;
  final String name;
  final String logoUrl;

  PlayerTeam(this.id, this.name, this.logoUrl);

  PlayerTeam.blank()
      : id = 0,
        name = "",
        logoUrl = "";

  factory PlayerTeam.fromJson(Map<String, dynamic> json) {
    return PlayerTeam(json['id'], json['name'], json['logo']);
  }
}

class PlayerStats {
  final int matches;
  final int goals;
  final int assists;
  final String rating;
  final int reds;
  final int yellows;
  final int fouls;

  PlayerStats(this.matches, this.goals, this.assists, this.rating, this.reds,
      this.yellows, this.fouls);

  PlayerStats.blank()
      : matches = 0,
        goals = 0,
        assists = 0,
        rating = "",
        reds = 0,
        yellows = 0,
        fouls = 0;

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
        json['games']["appearences"],
        json['goals']['total'],
        json['goals']['assists'],
        json["games"]["rating"],
        json["cards"]["red"],
        json["cards"]["yellow"],
        json["fouls"]["committed"]);
  }
}
