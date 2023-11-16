import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:football_app/models/squad.dart';

class SquadEndpoint {
  static Future<Squad> getSquadByTeamID(String id) async {
    final Uri uri = ApiManager.uri("/players/squads", queryParameters: {
      "team": id,
    });
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (!(body["response"].isEmpty)) {
        Squad squad = Squad.fromJson(body["response"][0]);
        return squad;
      }
      throw res.body;
    }
    throw res.body;
  }
}
