<img width="128" alt="dart-sanity-client-logo" src="https://github.com/user-attachments/assets/077aa24d-ea9e-42da-b5d7-f2dfa16775f6" />

# Dart Sanity Client
[![Dart](https://github.com/parkerhutchinson/dart_sanity_client/actions/workflows/dart.yml/badge.svg)](https://github.com/parkerhutchinson/dart_sanity_client/actions/workflows/dart.yml)

If you're like me and were disappointed to find that Sanity doesn't have an official Dart client, and underwhelmed by the alternatives available on pub.dev, this package is here for you. It's designed to meet most needs and deliver a robust HTTP client experience. Expect full http support with not just fetch, but also create, edit, delete, publish, unpublish, replaceDraft, and discard.

**NOTE: This package is currently in a beta period because there are still some things that need working out. Such as uploading assets and working in the mutations api.**

## Features

* full HTTP API support for sanity.io
* fetch, edit, delete, publish, unpublish, replaceDraft, and discard sanity object data.
* up to date client configuration options like perspective and tags.
* optional token for fetch requests.
* included cdn ref decoders for file and image.
* urlFor() method that nearly 1:1 mimics the JS client with full image parameter support.

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
2. using the transaction method to perform crud operations like create, edit, publish, and delete.
3. converting assets like files and images into urls you can use in your apps based on supplied sanity credentials.

All operations are methods from the `DartSanityClient` client instance. 
```dart
import 'package:dart_sanity_client/dart_sanity_client.dart';

final client = DartSanityClient(
  SanityConfig({
    dataset: 'yourdataset',
    projectId: 'yourprojectid',
  })
);

final results = client.fetch('*[_type == "post"]{title}');
```

The client defaults to `apicdn.sanity.io` but you can opt out of this by setting apiCdn to `false`. 


## Additional information


