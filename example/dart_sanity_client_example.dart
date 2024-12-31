import 'dart:convert';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:dart_sanity_client/dart_sanity_client.dart';

Future<dynamic> main() async {
  // quick formatter for pretty printing in console.
  JsonDecoder decoder = JsonDecoder();
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  void prettyPrintJson(String input) {
    var object = decoder.convert(input);
    var prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((element) => print(element));
  }

  // get .env file to test with private sanity creds
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  // client init
  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));

  final String query = '*[_type == "todo"]{image}';
  // fetch query using GROQ
  final results = await client.fetch(query);

  prettyPrintJson(results);
}
