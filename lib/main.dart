import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'cubit/jokes_cubit.dart';
import 'screens/jokes_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const JokesApp());
}

class JokesApp extends StatelessWidget {
  const JokesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<JokesCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Шутки',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: const JokesScreen(),
      ),
    );
  }
}
