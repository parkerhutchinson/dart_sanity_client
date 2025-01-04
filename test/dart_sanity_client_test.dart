import 'dart:convert';
import 'dart:io';
import 'package:dart_sanity_client/dart_sanity_client.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() async {
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  /// client cache
  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));

  /// results cache
  final results = await client.fetch('*[_type == "todo"]{title,image,file}');
  final resultsObj = jsonDecode(results);

  group('fetch:', () {
    test('simple fetch', () async {
      expect(resultsObj['result'][0]["title"], "testing dart sanity client");
    });
  });
  group('Client:', () {
    test('bad credentials', () async {
      final clientFail = DartSanityClient(SanityConfig(
          dataset: env['dataset'] ?? '',
          projectId: '' // omit the projecid to force the client to fail,
          ));
      try {
        await clientFail.fetch('*[_type == "todo"]{title}');
      } on ClientException catch (e) {
        expect(e.message, 'Failed host lookup: \'.apicdn.sanity.io\'');
      }
    });
  });

  group('Assets:', () {
    test('get asset image', () async {
      final imageResult =
          client.urlFor(resultsObj['result'][0]['image']['asset']['_ref']);
      expect(imageResult,
          'https://cdn.sanity.io/images/9czgqdka/production/722dc750ee3a0e2c8e9763a66f3722c66edba6c0-909x1095.png');
    });
    test('get asset file', () async {
      final fileResult =
          client.urlFor(resultsObj['result'][0]['file']['asset']['_ref']);
      expect(fileResult,
          'https://cdn.sanity.io/files/9czgqdka/production/447a8551ac3076fba419a02637ea49db068d45f3.pdf');
    });
  });
}
