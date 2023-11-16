import 'package:flutter/material.dart';
import 'package:football_app/endpoints/player_endpoint.dart';
import 'package:football_app/models/player.dart';
import 'package:football_app/components/default_appbar.dart';
import 'package:football_app/components/deafult_bottom_appbar.dart';
import 'package:football_app/components/detail_hero.dart';
import 'package:football_app/components/default_tab_bar.dart';
import 'package:football_app/components/player_profile_tile.dart';

class PlayerDetail extends StatefulWidget {
  final int playerId;
  final String playerName;
  final String photoUrl;
  const PlayerDetail(this.playerId, this.playerName, this.photoUrl,
      {super.key});

  @override
  createState() => _PlayerDetailState();
}

class _PlayerDetailState extends State<PlayerDetail>
    with TickerProviderStateMixin {
  _PlayerDetailState();
  bool loading = true;
  Player player = Player.blank();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (mounted) {
      loading = true;
      Player playerFromServer =
          await PlayerEndpoint.getPlayerByID(widget.playerId.toString());
      if (playerFromServer.stats.matches != 0) {
        loading = false;
      }

      setState(() {
        player = playerFromServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 1, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar("", AppBar()),
      body: Column(children: [
        DetailHero(widget.photoUrl, widget.playerName, player.team.name,
            "Player", widget.playerId),
        DefaultTabBar(tabController, const ["Profile"]),
        Flexible(
          child: TabBarView(controller: tabController, children: [
            Column(
              children: [(!loading) ? PlayerProfileTile(player) : Container()],
            ),
          ]),
        )
      ]),
    );
  }
}
