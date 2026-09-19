import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/game_controller.dart';
import 'screens/start_menu_screen.dart';
import 'theme/toy_pop_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations and system UI overlay
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ToyPopTheme.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        title: 'Tic Tac Toe - Party Duel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: ToyPopTheme.background,
          colorScheme: const ColorScheme.light(
            primary: ToyPopTheme.primary,
            secondary: ToyPopTheme.secondary,
            surface: ToyPopTheme.surface,
          ),
        ),
        home: const StartMenuScreen(),
      ),
    );
  }
}
