import 'package:http/http.dart' as http;
// import 'package:dart_sanity_client/src/http_client.dart';
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';

class DartSanityClient {
  final SanityConfig config;
  late http.Client httpClient;

  DartSanityClient(
    this.config, {
    final http.Client? httpClient,
  });

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return DecodeReponse(responseBody: response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 500:
      default:
        throw FetchDataException(
          '${response.statusCode} Server was unable to complete a request made by a client',
        );
    }
  }

  Future<dynamic> fetch(String query, {Map<String, dynamic>? params}) async {
    // final Uri uri = _buildUri(query, params: params);
    // final http.Response response = await _client.get(uri);
    return '_returnResponse(response)';
  }
}
