import 'package:flutter/material.dart';

import 'package:football_app/views/matches.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Matches());
  }
}
