import 'package:flutter/material.dart';
import 'package:football_app/models/player.dart';
import 'package:football_app/api_manager.dart';

class PlayerProfileTile extends StatelessWidget {
  final Player player;
  const PlayerProfileTile(this.player, {super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _renderFact(context, player.height, "Height"),
              _renderFact(context, "${player.age} years", player.birth),
              _renderFact(context, player.country, "Country"),
            ],
          ),
          _renderLeagueStats(context)
        ],
      ),
    );
  }

  Widget _renderRating(BuildContext context, double rating) {
    Color ratingcolor = Colors.black;
    if (rating <= 3.9) {
      ratingcolor = Colors.red.shade400;
    } else if (rating <= 4.9) {
      ratingcolor = Colors.red.shade300;
    } else if (rating <= 5.9) {
      ratingcolor = Colors.red.shade200;
    } else if (rating <= 6.9) {
      ratingcolor = Colors.grey;
    } else if (rating <= 7.9) {
      ratingcolor = Colors.green.shade200;
    } else if (rating <= 8.9) {
      ratingcolor = Colors.green.shade300;
    } else {
      ratingcolor = Colors.green;
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
              color: ratingcolor, borderRadius: BorderRadius.circular(5)),
          child: Text(
            rating.toStringAsFixed(2),
            style: const TextStyle(
                fontFamily: "Montserrat", fontWeight: FontWeight.w600),
          ),
        ),
        const Text(
          "Rating",
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _renderLeagueStats(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Colors.white))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _renderLeagueStatsHeading(context),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _renderFact(
                    context, player.stats.matches.toString(), "Matches"),
                _renderFact(context, player.stats.goals.toString(), "Goals"),
                _renderFact(
                    context, player.stats.assists.toString(), "Assists"),
                _renderRating(context, double.parse(player.stats.rating)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _renderFactIcon(
                  context, "assets/images/R.png", player.stats.reds),
              _renderFactIcon(
                  context, "assets/images/Y.png", player.stats.yellows),
              _renderFactIcon(
                  context, "assets/images/whistle.png", player.stats.fouls),
            ],
          )
        ],
      ),
    );
  }

  Widget _renderFactIcon(BuildContext context, String iconUrl, int factValue) {
    return Row(
      children: [
        SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(
              iconUrl,
              fit: BoxFit.contain,
            )),
        Text(
          factValue.toString(),
          style: const TextStyle(
              fontFamily: "Monsterrat",
              fontWeight: FontWeight.w600,
              fontSize: 15),
        ),
      ],
    );
  }

  Widget _renderLeagueStatsHeading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints.tightFor(width: 20, height: 20),
            child: Image.network(
              player.league.logoUrl,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            " ${player.league.name} ${ApiManager.currSeason}/${int.parse(ApiManager.currSeason) + 1}",
            style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _renderFact(BuildContext context, String primary, String secondary) {
    return Column(
      children: [
        Text(
          primary,
          style: const TextStyle(
              fontFamily: "Montserrat", fontWeight: FontWeight.w600),
        ),
        Text(
          secondary,
          style: const TextStyle(fontSize: 11),
        )
      ],
    );
  }
}
