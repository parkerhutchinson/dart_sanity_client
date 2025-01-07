<img width="128" alt="dart-sanity-client-logo" src="https://github.com/user-attachments/assets/077aa24d-ea9e-42da-b5d7-f2dfa16775f6" />

# Dart Sanity Client
[![Dart](https://github.com/parkerhutchinson/dart_sanity_client/actions/workflows/dart.yml/badge.svg)](https://github.com/parkerhutchinson/dart_sanity_client/actions/workflows/dart.yml)

If you're like me and were disappointed to find that Sanity doesn't have an official Dart client, and underwhelmed by the alternatives available on pub.dev, this package is here for you. It's designed to meet most needs and deliver a robust HTTP client experience. Expect full http support with not just fetch, but also create, edit, delete, publish, unpublish, replaceDraft, and discard.

## Features

* full HTTP API support for sanity.io
* fetch, edit, delete, publish, unpublish, replaceDraft, and discard sanity object data.
* up to date client configuration options like perspective and tags.
* optional token for fetch requests.
* included cdn ref decoders for file and image.
* urlFor() method that nearly 1:1 mimics the JS client with full image parameter support.
* groq and graphql support

## Getting started

create a DartSanityClient instance with a SanityConfig object:

```dart
import 'dart:convert';
import 'package:dart_sanity_client/dart_sanity_client.dart';

// init the client with minimal credentials for a public dataset
final client = DartSanityClient(
  SanityConfig({
    dataset: '',
    projectId: '',
  })
);

// fetch using GROQ queries
final results = await client.fetch('*[_type == "post"]');
print(results);

// results return a json string, use a decoder to convert it to an object
final decodedResults = jsonDecode(results);
print(decodedResults["result"]);
```

## Usage

**There are currently 3 main uses for this package:**

1. using groq to fetch data from your dataset
2. using the action method to perform crud operations like create, edit, publish, and delete.
3. converting assets like files and images into urls you can use in your apps based on supplied sanity credentials.

### Fetch

All operations are methods from the `DartSanityClient` client instance. 
```dart
import 'package:dart_sanity_client/dart_sanity_client.dart';

final client = DartSanityClient(
  SanityConfig({
    dataset: 'yourdataset',
    projectId: 'yourprojectid',
  })
);

final results = await client.fetch('*[_type == "post"]{title}');
```

The client defaults to `apicdn.sanity.io` but you can opt out of this by setting apiCdn to `false`.

GraphQL is also supported, you'll need to set `graphQl: true` in the SanityConfig constructor. All fetch requests from that point on will use the graphql endpoint. **NOTE:** you must first deploy your graphql enabled sanity studio, see official [docs on setting up graphql](https://www.sanity.io/docs/graphql#3af0194e8e42). Additionally if you have [multiple GraphQL datasets using tags](https://www.sanity.io/docs/graphql#e2e900be2233), you can tell the query to use a particular one by setting `graphQlTag: "foo"` in the fetch method.

### Assets
When writing groq queries you often get back asset refs instead of actually asset files. Or maybe you need to use the image api to manipulate the image to be blurry or rotated, `urlFor()` has you covered.

```dart
  /// passing in an image ref will return the proper
  /// CDN url for the asset
  final image = client.urlFor('image-adf124-200x200-jpg');
  /// https://cdn.sanity.io/images/{projectid}/{dataset}/adf124.jpg

  /// this works for files as well
  final image = client.urlFor('file-adf124-pdf');
  /// https://cdn.sanity.io/files/{projectId}/{dataset}/adf124.pdf

  /// with images you can pass in parameters to manipulate the image in various ways
  final blurImage = client.urlFor('image-adf124-200x200-jpg', options: ImageOptions(blur: 100));
  /// description of each option can be found on sanity.io https://www.sanity.io/docs/image-urls#BhPyF4m0
```

### Actions
A major pillar of the http client is the actions API. You can perform a number of crud operations on your dataset. Running actions on a dataset is as easy as calling the `action` method on the client instance. Each action has its own constructor and actions can be performed in bulk thanks to how the API functions. 

```dart
  import 'package:dotenv/dotenv.dart';
  /// highly suggest using some sort of dotfile loader for your credentials
  Directory current = Directory.current;
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['${current.path}/.env']);

  final client = DartSanityClient(
    SanityConfig(
      dataset: env['dataset'] ?? '',
      projectId: env['projectId'] ?? '',
      /// token is required for the action to function. you'll 
      /// need to generate a token with write permsissions.
      token: env['token'],
    ),
  );
  /// publish ID
  final String pid = 'foo';
  /// draft ID
  final String did = 'drafts.$pid';
  /// create a new post document with a title field. 
  /// both `_id` an `_type` are required for create actions to function.
  final createA = CreateAction(
    publishedId: pid, 
    attributes: {
       "_id": pid,
       "_type": "post",
       "title": "hello world!",
     },
   );
  final publishA = PublishAction(publishedId: pid, draftId: did);
  /// actions are passed as an array. each action runs in sequence, 
  /// but the transaction happens in a single operation.
  /// here we create our post and publish it. setting dryRun 
  /// to true will only validate the opteration will be successful.
  /// If you receive a transaction id, then no errors were found and its safe 
  /// to remove the dryRun parameter(defaults to false).
  final runActions = await client.action([createA, publishA], dryRun: true); 

```

see the official docs for a full list of actions you can use with this package https://www.sanity.io/docs/http-actions#5e9fc8d16fe1



