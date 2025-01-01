import 'dart:convert';

import 'package:dart_sanity_client/src/file_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/assets.dart';
import 'package:dart_sanity_client/src/uri_builder.dart';
import 'package:dart_sanity_client/src/actions.dart';

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

  /// the transaction method simply runs an array of actions as a single transaction.
  /// this is how the sanity http API functions. you can do two things(or more) at once.
  /// create a draft and publish it in one step. This is handy especially when you are writting an app.
  ///
  ///
  Future<dynamic> transaction(
    final List<dynamic> transaction, {
    bool dryRun = false,
    bool referenceValidation = false,
    String? transactionId,
  }) async {
    if (config.token == null) {
      throw Exception(
          "'token' in SanityConfig not set. Token with read/write access is required to run transactions.");
    }
    final List<String> stringifyTransactions =
        transaction.map((d) => jsonEncode(d.toJson())).toList();

    /// I hate this but something funky happens when you try to convert a map to a string. it tries to escape all the quotes.
    /// need to come back to this because I just dont know the right way to process this.
    String actions =
        '{"actions": $stringifyTransactions,"dryRun": $dryRun,"skipCrossDatasetReferenceValidation": $referenceValidation}';

    if (transactionId != null) {
      actions =
          '{"actions": $stringifyTransactions,"dryRun": $dryRun,"skipCrossDatasetReferenceValidation": $referenceValidation, "transactionId": $transactionId}';
    }
    final Uri uri = URI_Builder(config: config).action();
    final http.Response response = await httpClient.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${config.token}',
        'content-type': 'application/json'
      },
      body: actions,
    );
    httpClient.close();
    return _returnResponse(response);
  }

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
