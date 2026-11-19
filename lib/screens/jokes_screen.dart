import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/jokes_cubit.dart';
import '../cubit/jokes_state.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<JokesCubit>().loadJoke();
  }

  Widget jokeList(List<String> jokes, JokesState state) {
    if (jokes.isEmpty) {
      return const Center(child: Text('Пока здесь пусто'));
    }
    return ListView.builder(
      itemCount: jokes.length,
      itemBuilder: (context, index) {
        final joke = jokes[index];
        return Card(
          child: ListTile(
            title: Text(joke),
            onTap: () {
              context.read<JokesCubit>().showFromHistory(joke);
              setState(() => selectedTab = 0);
            },
            trailing: IconButton(
              icon: Icon(state.favorites.contains(joke)
                  ? Icons.favorite : Icons.favorite_border),
              onPressed: () => context.read<JokesCubit>().toggleFavorite(joke),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шутки'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<JokesCubit, JokesState>(
        builder: (context, state) {
          if (selectedTab == 1) return jokeList(state.history, state);
          if (selectedTab == 2) return jokeList(state.favorites, state);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sentiment_very_satisfied, size: 70, color: Colors.blue),
                const SizedBox(height: 20),
                const Text('Случайная шутка', style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                if (state.loading) const CircularProgressIndicator(),
                if (!state.loading)
                  Text(state.joke ?? 'Нажми кнопку, чтобы получить шутку',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19)),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  Text(state.error!, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: state.loading ? null : () => context.read<JokesCubit>().loadJoke(),
                  child: const Text('Следующая шутка'),
                ),
                if (state.joke != null)
                  TextButton.icon(
                    onPressed: () => context.read<JokesCubit>().toggleFavorite(state.joke!),
                    icon: Icon(state.favorites.contains(state.joke!)
                        ? Icons.favorite : Icons.favorite_border),
                    label: Text(state.favorites.contains(state.joke!)
                        ? 'Убрать из избранного' : 'В избранное'),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) => setState(() => selectedTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Шутки'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
        ],
      ),
    );
  }
}
