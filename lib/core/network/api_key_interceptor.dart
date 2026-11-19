import 'package:dio/dio.dart';
import '../../api_config.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Api-Key'] = ApiConfig.apiKey;
    handler.next(options);
  }
}
