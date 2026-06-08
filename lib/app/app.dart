import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduvillage/app/routes.dart';
import 'package:eduvillage/app/theme.dart';
import 'package:eduvillage/providers/coin_provider.dart';
import 'package:eduvillage/providers/game_provider.dart';
import 'package:eduvillage/utils/constants.dart';

/// Main App Widget
class EduVillageApp extends StatefulWidget {
  const EduVillageApp({Key? key}) : super(key: key);

  @override
  State<EduVillageApp> createState() => _EduVillageAppState();
}

class _EduVillageAppState extends State<EduVillageApp> {
  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    // Initialize coin provider
    await context.read<CoinProvider>().initialize();
    // Initialize game provider
    await context.read<GameProvider>().initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
