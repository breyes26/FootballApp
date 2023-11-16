import 'package:flutter/material.dart';

class DefaultTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabTitles;
  const DefaultTabBar(this.tabController, this.tabTitles, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: const Border(
              top: BorderSide(color: Colors.white),
            )),
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: 35,
          child: TabBar(
              labelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600),
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelPadding: const EdgeInsets.only(left: 20, right: 20),
              labelColor: Colors.black,
              isScrollable: true,
              controller: tabController,
              unselectedLabelColor: Colors.grey,
              tabs: tabTitles.map((e) => Tab(text: e)).toList()),
        ),
      ),
    );
  }
}
