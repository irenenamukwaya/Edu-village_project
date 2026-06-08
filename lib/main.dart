import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/app/app.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/providers/game_provider.dart';

// Boots the app with shared providers before launch.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const EduVillageApp(),
    ),
  );
}
