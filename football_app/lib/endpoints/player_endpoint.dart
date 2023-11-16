import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:football_app/models/player.dart';
import 'dart:convert';

class PlayerEndpoint {
  static const _popularPlayers = ["762", "276", "154", "278", "1100", "874"];
  static Future<Player> getPlayerByID(String id) async {
    final Uri uri = ApiManager.uri("/players",
        queryParameters: {"id": id, "season": ApiManager.currSeason});
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      Player team = Player.fromJson(body["response"][0]);
      return team;
    }
    throw res.body;
  }

  static Future<List<Player>> getPlayersByTeamID(String id) async {
    List<Player> players = [];
    final Uri uri = ApiManager.uri("/players",
        queryParameters: {"team": id, "season": ApiManager.currSeason});
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      for (int i = 0; i < body['response'].length; i++) {
        players.add(Player.fromJson(body['response'][i]));
      }
      return players;
    }
    throw res.body;
  }

  static Future<List<Player>> getPopularPlayers() async {
    int received = 0;
    List<Player> result = [];
    while (received < _popularPlayers.length) {
      try {
        Future<Player> futureLeague = getPlayerByID(_popularPlayers[received]);
        result.add(await futureLeague);
      } catch (e) {
        print(e);
      }
      received++;
    }

    return result;
  }
}
