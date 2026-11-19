class JokesState {
  final String? joke;
  final bool loading;
  final String? error;
  final List<String> history;
  final List<String> favorites;

  const JokesState({
    this.joke,
    this.loading = false,
    this.error,
    this.history = const [],
    this.favorites = const [],
  });
}
