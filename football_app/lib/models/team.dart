class Team {
  final int id;
  final String name;
  final int founded;
  final String logoUrl;
  final Venue venue;

  Team(this.id, this.name, this.founded, this.logoUrl, this.venue);

  Team.blank()
      : id = 0,
        name = "",
        founded = 0,
        logoUrl = "",
        venue = Venue.blank();

  factory Team.fromJson(Map<String, dynamic> json) {
    final teamInfo = json['team'];
    final venueInfo = json['venue'];
    return Team(teamInfo['id'], teamInfo['name'], teamInfo['founded'],
        teamInfo['logo'], Venue.fromJson(venueInfo));
  }
}

class Venue {
  final int id;
  final String name;
  final String city;
  final String imageUrl;

  Venue.blank()
      : id = 0,
        name = "",
        city = "",
        imageUrl = "";

  Venue(this.id, this.name, this.city, this.imageUrl);

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(json['id'], json['name'], json['city'], json['image']);
  }
}
