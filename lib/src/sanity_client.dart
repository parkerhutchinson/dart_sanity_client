import 'package:dart_sanity_client/src/file_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/assets.dart';
import 'package:dart_sanity_client/src/uri_builder.dart';

class DartSanityClient {
  final SanityConfig config;
  http.Client httpClient;

  DartSanityClient(
    this.config, {
    final http.Client? httpClient,
    // we need to init the http client for it to actually work.
  }) : httpClient = httpClient ?? http.Client();
  // groq queries
  Future<dynamic> fetch(final String query) async {
    final Uri uri = URI_Builder(config: config).query(query);
    final http.Response response = await httpClient.get(uri);
    httpClient.close();
    return _returnResponse(response);
  }

  /// image and file asset url builder.
  ///
  /// [String], [ImageOptions]
  dynamic urlFor(
    final String assetRef, {
    final ImageOptions? options,
  }) {
    Uri uri;

    if (FileDecoder.type(assetRef) == "image") {
      uri = URI_Builder(config: config).image(assetRef, options: options);
    } else if (FileDecoder.type(assetRef) == "file") {
      uri = URI_Builder(config: config).file(assetRef);
    } else {
      throw Exception(
          'asset ref must be either file or image, neither was provided. make sure the ref is properly formatted eg: file-asdf2233...-pdf or image-asdf2233...-200x200-jpg.');
    }

    return uri;
  }

  Future<dynamic> create(final String query) async {}
  Future<dynamic> delete(final String query) async {}
  Future<dynamic> publish(final String query) async {}

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
