class Squad {
  final int teamID;
  final List<SquadPlayer> squad;

  Squad(this.teamID, this.squad);

  Squad.blank()
      : teamID = 0,
        squad = [];

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(json['team']['id'], _parseSquad(json['players']));
  }
}

List<SquadPlayer> _parseSquad(List<dynamic> squad) {
  List<SquadPlayer> l = [];
  for (int i = 0; i < squad.length; i++) {
    if (squad[i]["number"] != null) {
      l.add(SquadPlayer.fromJson(squad[i]));
    }
  }

  return l;
}

class SquadPlayer {
  final int id;
  final String name;
  final int number;
  final String photoUrl;
  final String position;

  SquadPlayer(this.id, this.name, this.number, this.photoUrl, this.position);

  SquadPlayer.blank()
      : id = 0,
        name = "",
        number = 0,
        photoUrl = "",
        position = "";

  factory SquadPlayer.fromJson(Map<String, dynamic> json) {
    return SquadPlayer(json['id'], json['name'], json["number"], json["photo"],
        json["position"]);
  }
}
