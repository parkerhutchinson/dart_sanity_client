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
- added in some unit tests which led to the discovery of above bugs.

## 0.3.1

- added all missing api documentation
- fixed all linting warnings

## 0.4.0

*bugs*
- fixed an issue where the perspective was never being set in the fetch request
- fixed an issue where the tag was never being set in the uri builder
- fixed an issue where the token would not be passed ever to the fetch request if it was supplied.

*new*
- graphql support has been added via a new config parameter `graphQl: true`
- gave fetch a new parameter `authorized: true` to force the fetch request to use the token.
- changed the `tag` parameter to `requestTagPrefix` to match the official client config. this now properly appends the tag to the fetch request for logging perpuses.
- graphql support also includes a new parameter to fetch which sets the graphql tag for the query. graphQlTag: 'foo' will query the graphql dataset with the foo tag associated with it. https://www.sanity.io/docs/graphql#e2e900be2233 