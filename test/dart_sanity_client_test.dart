import 'dart:convert';
import 'dart:io';
import 'package:dart_sanity_client/dart_sanity_client.dart';
import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';

void main() async {
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));

  group('fetch groq', () {
    test('client configuration', () async {
      final String results = await client.fetch('*[_type == "todo"]{title}');
      final resultsObject = jsonDecode(results);
      expect(resultsObject['result'][0]["title"], "testing dart sanity client");
    });
  });
}
