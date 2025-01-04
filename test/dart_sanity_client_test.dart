import 'dart:convert';
import 'dart:io';
import 'package:dart_sanity_client/dart_sanity_client.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:dart_sanity_client/src/http_response.dart';

void main() async {
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));

  group('fetch groq', () {
    test('simple fetch', () async {
      final String results = await client.fetch('*[_type == "todo"]{title}');
      final resultsObject = jsonDecode(results);
      expect(resultsObject['result'][0]["title"], "testing dart sanity client");
    });
    test('failed fetch', () async {
      try {
        await client.fetch('*[_type == "todo"]{title}');
      } on ClientException catch (e) {
        expect(e.message, 'HTTP request failed. Client is already closed.');
      }
    });
  });
}
