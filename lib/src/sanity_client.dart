import 'dart:convert';
import 'dart:io';
import 'package:dart_sanity_client/src/file_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:dart_sanity_client/src/http_response.dart';
import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/assets.dart';
import 'package:dart_sanity_client/src/uri_builder.dart';

class ParseDataStream {}

/// DartSanityClient class used for fetch(), urlFor(), and action()
class DartSanityClient {
  /// sanity configuration object.
  final SanityConfig config;
  // ignore: public_member_api_docs
  http.Client httpClient;

  /// create a dart sanity client instance using a SanityConfig object
  DartSanityClient(
    this.config, {
    final http.Client? httpClient,
    // we need to init the http client for it to actually work.
  }) : httpClient = httpClient ?? http.Client();

  /// run groq of graphql queries
  /// pass authorized: true to fetch using the token
  Future<dynamic> fetch(
    final String query, {
    bool authorized = false,
    String? graphQlTag,
  }) async {
    final Uri uri = URI_Builder(config: config).query(
      query,
      graphQlTag: graphQlTag,
      params: {'perspective': config.perspective},
    );

    final dynamic response = await httpClient.get(
      uri,
      headers: {
        if (config.token != null && authorized)
          'Authorization': 'Bearer ${config.token}',
      },
    );

    return _returnResponse(response);
  }

  Stream live(
    final String query, {
    bool authorized = false,
  }) async* {
    final Uri uri = URI_Builder(config: config).query(
      query,
      params: {'perspective': config.perspective},
    );
    final request = http.Request("GET", uri);

    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${config.token}'});

    final http.StreamedResponse response = await httpClient.send(request);

    int startIndex = -1;
    int endIndex = -1;

    List<int> buf = [];
    String? processData(dynamic data, int endIndex, int startIndex) {
      for (var i = 0; i < data.length - 1; i++) {
        if (data[i] == 0xff && data[i + 1] == 0xd8) {
          startIndex = buf.length + i;
        }
        if (data[i] == 0xff && data[i + 1] == 0xd9) {
          endIndex = buf.length + i;
        }
      }

      if (data != 10) {
        buf.addAll(data);
      }

      /// someone smarter than I will need to come up with a safer way of returning
      /// the chunked out value. since this seems to return a butt load of linebreaks and spaces
      /// but for now this magic number seems to work.
      return buf.length <= 40 ? null : utf8.decode(buf).trim();
    }

    yield* response.stream.asyncMap(
      (data) async => processData(
        data,
        startIndex,
        endIndex,
      ),
    );
  }

  /// Image and File asset url builder. simply supply the image or file ref id and
  /// it will spit back the proper cdn result. images support all of the options available
  /// here: https://www.sanity.io/docs/image-urls#BhPyF4m0 except for dl and dlraw. since those would
  /// require an actual browser. This might be added in the future if people request it.
  /// you can always just append those parameters to the string to add that functionalty in adhoc.
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

    return uri.toString();
  }

  /// The transaction method simply runs an array of actions as a single transaction.
  /// this is how the sanity http API functions. you can do two things(or more) at once.
  /// create a draft and publish it in one step. This is handy especially when you are writting an app.
  Future<dynamic> action(
    final List<dynamic> transaction, {
    bool dryRun = false,
    bool referenceValidation = false,
    String? transactionId,
  }) async {
    if (config.token == null) {
      throw Exception(
          "'token' in SanityConfig not set. Token with read/write access is required to run transactions.");
    }
    final List<String> stringifyTransactions = transaction.map((d) {
      return jsonEncode(d.toJson());
    }).toList();

    /// I hate this but something funky happens when you try to convert a map to a string.
    /// it tries to escape all the quotes. need to come back to this because I just
    /// dont know the right way to process this.
    String actions = '''{
        "actions": $stringifyTransactions,
        "dryRun": $dryRun,
        "skipCrossDatasetReferenceValidation": $referenceValidation
        }
        ''';

    if (transactionId != null) {
      actions = '''{
          "actions": $stringifyTransactions,
          "dryRun": $dryRun,
          "skipCrossDatasetReferenceValidation": $referenceValidation, 
          "transactionId": $transactionId
          }''';
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
