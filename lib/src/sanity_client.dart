import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';

class DartSanityClient {
  final SanityConfig config;
  http.Client httpClient;

  DartSanityClient(
    this.config, {
    final http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Uri _buildUri(String query, {Map<String, dynamic>? params}) {
    final Map<String, dynamic> queryParameters = {
      'query': query,
      if (params != null) ...params,
    };
    return Uri(
      scheme: 'https',
      host: '${config.projectId}.api.sanity.io',
      path: '/v1/data/query/${config.dataset}',
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> fetch(String query) async {
    final Uri uri = _buildUri(query);
    final http.Response response = await httpClient.get(uri);
    httpClient.close();
    return _returnResponse(response);
  }

  dynamic _response(final String body) {
    final responseJson = jsonDecode(body);
    return responseJson['result'];
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
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
}
