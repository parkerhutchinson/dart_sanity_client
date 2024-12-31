import 'package:http/http.dart' as http;
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/uri_builder.dart';

class DartSanityClient {
  final SanityConfig config;
  http.Client httpClient;

  DartSanityClient(
    this.config, {
    final http.Client? httpClient,
    // we need to init the http client for it to actually work.
  }) : httpClient = httpClient ?? http.Client();

  Future<dynamic> fetch(String query) async {
    final Uri uri = URI_Builder(config: config).query(query);
    final http.Response response = await httpClient.get(uri);
    ImageOptions();
    // we need this here otherwise the client hangs for a really long time
    httpClient.close();
    return _returnResponse(response);
  }

  Future<dynamic> create(String query) async {}
  Future<dynamic> delete(String query) async {}
  Future<dynamic> publish(String query) async {}

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // unlike the other packages we dont force any formatting here.
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
