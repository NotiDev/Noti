import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'providers/notes_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'Noti App',
        theme: ThemeData(
          primarySwatch: Colors.blue, // здесь меняем на синий
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, // цвет AppBar
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, // цвет FAB
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(Colors.blue), // цвет чекбоксов
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
