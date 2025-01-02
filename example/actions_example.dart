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

  const pid = "testingTransactions";
  const did = "drafts.$pid";

  // final createT = CreateTransaction(publishedId: pid, attributes: {
  //   "_id": did,
  //   "_type": "todo",
  //   "title": "hello world!",
  // });
  final publishT = PublishAction(publishedId: pid, draftId: did);
  // final editT = EditTransaction(publishedId: pid, draftId: did, patch: {
  //   "set": {
  //     "title": "new title",
  //   }
  // });
  // final deleteT = DeleteTransaction(publishedId: pid);

  final runTransaction = await client.action([publishT], dryRun: false);
  print(runTransaction);
}
