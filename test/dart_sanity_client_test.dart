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

  group('fetch groq', () {
    test('simple fetch', () async {
      final client = DartSanityClient(SanityConfig(
        dataset: env['dataset'] ?? '',
        projectId: env['projectId'] ?? '',
      ));
      final String results = await client.fetch('*[_type == "todo"]{title}');
      final resultsObject = jsonDecode(results);
      expect(resultsObject['result'][0]["title"], "testing dart sanity client");
    });
    test('bad credentials', () async {
      final client = DartSanityClient(SanityConfig(
          dataset: env['dataset'] ?? '',
          projectId: '' // omit the projecid to force the client to fail,
          ));
      try {
        await client.fetch('*[_type == "todo"]{title}');
      } on ClientException catch (e) {
        expect(e.message, 'Failed host lookup: \'.apicdn.sanity.io\'');
      }
    });
  });
  group('Assets', () {
    final client = DartSanityClient(SanityConfig(
      dataset: env['dataset'] ?? '',
      projectId: env['projectId'] ?? '',
    ));
    test('get asset image', () async {
      final queryResults = await client.fetch('*[_type == "todo"]{image}');
      final resultsObj = jsonDecode(queryResults);
      final imageResult =
          client.urlFor(resultsObj['result'][0]['image']['asset']['_ref']);
      expect(imageResult,
          'https://cdn.sanity.io/images/9czgqdka/production/722dc750ee3a0e2c8e9763a66f3722c66edba6c0-909x1095.png');
    });
    test('get asset file', () async {
      final queryResults = await client.fetch('*[_type == "todo"]{file}');
      final resultsObj = jsonDecode(queryResults);
      final imageResult =
          client.urlFor(resultsObj['result'][0]['file']['asset']['_ref']);
      print(imageResult);
      expect(imageResult,
          'https://cdn.sanity.io/images/9czgqdka/production/722dc750ee3a0e2c8e9763a66f3722c66edba6c0-909x1095.png');
    });
  });
}
