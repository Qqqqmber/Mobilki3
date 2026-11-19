import 'package:dio/dio.dart';

class JokesRepository {
  final Dio dio;
  JokesRepository(this.dio);

  Future<String> getJoke() async {
    final response = await dio.get('/dadjokes');
    final data = response.data;
    if (data is List && data.isNotEmpty && data.first is Map) {
      final joke = data.first['joke'];
      if (joke is String && joke.trim().isNotEmpty) return joke;
    }
    throw Exception('Сервер не вернул шутку');
  }
}
