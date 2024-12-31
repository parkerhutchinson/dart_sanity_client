If you're like me and were disappointed to find that Sanity doesn't have an official Dart client, and underwhelmed by the alternatives available on pub.dev, this package is here to change that. It's designed to meet our needs and deliver a robust HTTP client experience. Expect full http support with not just fetch, but also create, patch, publish, and delete.

## Features

* full HTTP API support for sanity.io
* fetch, create, patch, publish, and delete sanity object data.
* up to date client configuration options like perspective and tags.
* optional token for fetch requests.
* included cdn ref decoders. 
* streamlined DX for optimal use.

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
```dart
const like = 'sample';
```

## Additional information


