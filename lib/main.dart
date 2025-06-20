import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/screens/HomeScreen.dart';
import 'package:pet_adoption_app/screens/navigationscreen.dart';
import 'PetRepository.dart';
import 'bloc/pet_bloc.dart';
import 'bloc/pet_event.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PetRepository repository = PetRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,

      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => PetBloc(repository)..add(LoadPets()),
        child: MainNavigationScreen(),
      ),
    );
  }
}