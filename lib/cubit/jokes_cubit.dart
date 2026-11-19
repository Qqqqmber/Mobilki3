import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/jokes_repository.dart';
import 'jokes_state.dart';

class JokesCubit extends Cubit<JokesState> {
  final JokesRepository repository;
  JokesCubit(this.repository) : super(const JokesState());

  Future<void> loadJoke() async {
    if (state.loading) return;
    emit(JokesState(
      joke: state.joke,
      loading: true,
      history: state.history,
      favorites: state.favorites,
    ));
    try {
      final joke = await repository.getJoke();
      final history = List<String>.from(state.history);
      history.remove(joke);
      history.insert(0, joke);
      if (history.length > 20) history.removeLast();
      emit(JokesState(joke: joke, history: history, favorites: state.favorites));
    } on DioException catch (error) {
      String message = 'Не удалось загрузить шутку. Проверь интернет.';
      if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
        message = 'Ошибка API-ключа или доступа к API';
      } else if (error.response?.statusCode == 429) {
        message = 'Слишком много запросов. Попробуй позже';
      }
      emit(JokesState(joke: state.joke, error: message,
          history: state.history, favorites: state.favorites));
    } catch (_) {
      emit(JokesState(joke: state.joke, error: 'Ошибка получения шутки',
          history: state.history, favorites: state.favorites));
    }
  }

  void toggleFavorite(String joke) {
    final favorites = List<String>.from(state.favorites);
    if (favorites.contains(joke)) {
      favorites.remove(joke);
    } else {
      favorites.add(joke);
    }
    emit(JokesState(joke: state.joke, history: state.history, favorites: favorites));
  }

  void showFromHistory(String joke) {
    emit(JokesState(joke: joke, history: state.history, favorites: state.favorites));
  }
}
