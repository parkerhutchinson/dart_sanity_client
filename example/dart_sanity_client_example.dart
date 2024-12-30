import 'dart:convert';

import 'package:dart_sanity_client/dart_sanity_client.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart';

Future<dynamic> main() async {
  JsonDecoder decoder = JsonDecoder();
  JsonEncoder encoder = JsonEncoder.withIndent('  ');

  void prettyPrintJson(String input) {
    var object = decoder.convert(input);
    var prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((element) => print(element));
  }

  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);
  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));
  final String query = '*[]';
  final results = await client.fetch(query);

  prettyPrintJson(results);
}
