import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:dart_sanity_client/dart_sanity_client.dart';

void main() async {
  // get .env file to test with private sanity creds
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final DartSanityClient client = DartSanityClient(
    SanityConfig(
      dataset: env['dataset'] ?? '',
      projectId: env['projectId'] ?? '',
      token: env['tokenWrite'],
    ),
  );

  const String pid = "testingTransactions";
  const String did = "drafts.$pid";

  final CreateAction createA = CreateAction(publishedId: pid, attributes: {
    "_id": did,
    "_type": "todo",
    "title": "hello world!",
  });
  final PublishAction publishA = PublishAction(publishedId: pid, draftId: did);
  final EditAction editA = EditAction(publishedId: pid, draftId: did, patch: {
    "set": {
      "title": "new title",
    }
  });
  final deleteA = DeleteAction(publishedId: pid);

  final dynamic create = await client.action([createA]);

  /// edit and publish in one transaction
  final dynamic editPublish = await client.action([editA, publishA]);
  final dynamic delete = await client.action([deleteA]);

  print(create); // transaction id = success
  print(editPublish); // transaction id = success
  print(delete); // transaction id = success
}
