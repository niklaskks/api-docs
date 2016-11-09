# Collections

Collections bundle Document objects. All such Documents are rendered using the same training from their Collection.

## List Collections
Shows paginated list of all Collections the user has access to.

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v2/collections/ \
  --header 'Authorization: Token f30d6b31bec34e3abe945fac786672fe'
```

> The API returns a JSON string, such as:
```json
{ "count":1,
  "next":null,
  "previous":null,
  "results":[{ "id":11,
    "created":"2016-11-08T14:32:55.612102Z",
    "modified":"2016-11-08T14:32:55.612137Z",
    "celery_queue_suffix":"",
    "es_doc_type":null,
    "es_search_query":null,
    "es_taxonomy_processed":false,
    "flags":{
      "suppress_autoregeneration":false,
      "autogenerate":false},
    "license_holder":"customer-group-19",
    "language":"en-US",
    "name":"Test Collection",
    "training_id":111,
    "uses_published_training":false,
    "webhook_secret":"eiuriewqrm324321n32b4n3v21b4",
    "webhook_url":null,
    "document_processing_states":{"none":10,"generated":1000}}
]}
```

### Endpoint
`GET /v2/collections/`

## Create a new Collection
```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/collections/' \
  --header 'Authorization: Token bd800b0689384091936f0bec670a3e78' \
  --data '{"name":"Demo collection","language":"en-US","training_id":333}'
```

### Endpoint
`POST /v2/collections/`

## Show a single Collection object
```shell
$ curl --request GET \
  --url http://api.ax-semantics.com/v2/collections/11/ \
  --header 'Authorization: Token f1a9f7aa3dc545bbbf2b4d88c4713e86'
```

> The API returns a JSON response, such as:

```json
{ "id":11,
  "created":"2016-11-08T14:32:55.612102Z",
  "modified":"2016-11-08T14:32:55.612137Z",
  "celery_queue_suffix":"",
  "es_doc_type":null,
  "es_search_query":null,
  "es_taxonomy_processed":false,
  "flags":{
    "suppress_autoregeneration":false,
    "autogenerate":false},
  "license_holder":"customer-group-19",
  "language":"en-US",
  "name":"Test Collection",
  "training_id":111,
  "uses_published_training":false,
  "webhook_secret":"eiuriewqrm324321n32b4n3v21b4",
  "webhook_url":null,
  "document_processing_states":{"none":10,"generated":1000}}
```

### Endpoint
`GET /v2/collections/{CID}/`

Replace `{CID}` with a valid Collection ID.


## Update an existing Collection
```shell
$ curl --request PATCH \
  --url 'https://api.ax-semantics.com/v2/collections/11/' \
  --header 'Authorization: Token 535c66208b224449a834e91bae76b953' \
  --data '{"webhook_url":"http://example.com/backdoor/"}'
```

### Endpoint
`PATCH /v2/collections/{CID}/`

Replace `{CID}` with a valid Collection ID.

## Delete a Collection
```shell
$ curl --request DELETE \
  --url 'https://api.ax-semantics.com/v2/collections/22/' \
  --header 'Authorization: Token d63bcc2f75e8495493898334f197b01c'
```
Eventually the Collection and all its corresponding Documents will be removed from our database.

<aside class="warning">
Be careful with this command: The API does not ask for confirmation but immediately executes your request.
</aside>

### Endpoint
`DELETE /v2/collections/{CID}/`

Replace `{CID}` with a valid Collection ID.

## Generate content for all Documents in a Collection
```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/collections/11/generate-content/' \
  --header 'Authorization: Token 759193889f174c33922a909ddece262a'
```

### Endpoint
`POST /v2/collections/{CID}/generate-content/`

Replace `{CID}` with a valid Collection ID.
