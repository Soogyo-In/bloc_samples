import 'package:bloc_samples/multi_bloc/multi_bloc_page.dart';
import 'package:bloc_samples/repository/calender_repository.dart';
import 'package:bloc_samples/repository/memo_repository.dart';
import 'package:bloc_samples/repository/weather_repository.dart';
import 'package:bloc_samples/scoped_state_bloc/scoped_state_bloc_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => WeatherRepository()),
        RepositoryProvider(create: (context) => CalenderRepository()),
        RepositoryProvider(create: (context) => MemoRepository()),
      ],
      child: const MaterialApp(home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bloc samples')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.maybeOf(context)?.push(
                MaterialPageRoute(
                  builder: (context) => const ScopedStateBlocPage(),
                ),
              ),
              child: const Text('scoped state bloc'),
            ),
            TextButton(
              onPressed: () => Navigator.maybeOf(context)?.push(
                MaterialPageRoute(
                  builder: (context) => const MultiBlocPage(),
                ),
              ),
              child: const Text('multi bloc'),
            ),
          ],
        ),
      ),
    );
  }
}
