import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:dart_sanity_client/dart_sanity_client.dart';

void main() async {
  // get .env file to test with private sanity creds
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final client = DartSanityClient(SanityConfig(
    dataset: env['dataset'] ?? '',
    projectId: env['projectId'] ?? '',
    token: env['tokenWrite'],
  ));
  final createT = CreateTransaction(publishedId: 'testing4', attributes: {
    "_id": "drafts.testing4",
    "_type": "todo",
    "title": "hello world!"
  });
  final publishT =
      PublishTransaction(publishedId: 'testing4', draftId: 'drafts.testing4');

  final runTransaction = await client.transaction([createT, publishT]);
  print(runTransaction);
}
