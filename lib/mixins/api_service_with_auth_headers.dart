import 'package:simpledebts/mixins/api_service.dart';

class ApiServiceWithAbstractHeaders extends ApiService {
  Map<String, String> _authHeaders;

  void setupAuthHeader(Map<String, String> headers) {
    _authHeaders = headers;
  }

  Map<String, String> get authHeaders {
    return {..._authHeaders};
  }
}