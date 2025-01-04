## 0.1.0

- all crud options as advertised
- urlFor() for both image and file
- image and file ref decoders that return an object with possibilities for prefix, id, width, height, asset
- transaction method that runs multiple transactions at once via an array such as [CreateTransaction(), EditTransaction(), PublishTransaction(), ...]

## 0.1.1

- fixing documentation typos

## 0.1.2

- fixing documentation typos

## 0.2.0

- cleanup of static class getters
- converted transaction to action to closer mimic sanity api
- documentations updates

## 0.3.0

*bugs*
- fixed issue where urlFor was not returning an actually string url like it was suppose to.
- fixed issue where multiple requests of the same fetch failed due to closing the http client.

*new*
- added in unit some unit tests which led to the discovery of above bugs.
