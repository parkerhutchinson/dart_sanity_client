import 'dart:io';
import 'package:dart_sanity_client/src/assets.dart';
import 'package:dotenv/dotenv.dart';
import 'package:dart_sanity_client/dart_sanity_client.dart';

Future<dynamic> main() async {
  // get .env file to test with private sanity creds
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
  ));

  /// using the image ref and provided options construct an image uri.
  final imageResults = client.urlFor(
      'image-722dc750ee3a0e2c8e9763a66f3722c66edba6c0-909x1095-png',
      options: ImageOptions(
        blur: 100,
        orientation: 90,
      ));

  /// using a file ref get a file uri, options do nothing for files as they have no query options.
  final fileResults =
      client.urlFor('file-447a8551ac3076fba419a02637ea49db068d45f3-pdf');

  final badResults =
      client.urlFor('447a8551ac3076fba419a02637ea49db068d45f3-pdf');

  print(imageResults);
  print(fileResults);
}
