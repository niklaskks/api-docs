# v2 API
<aside>
the v2 API is our new api. use this, if you are using the new Cloud Cockpit. 

* Documents replace "Things" from v1
* Collections replace "Content Projects" from v1
</aside>

# Documents
We store your data in Documents. Each Document belongs to exactly one Collection.

## Create a new Document
```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/collections/1/document/' \
  --header 'Authorization: Token 7de3adb043d74ca79de98cc5b6d7c405' \
  --header 'Content-Type: application/json' \
  --data '{"uid": 222333,"name":"demo","capacity":{"unit":"F","value":4"}'
```

To create a new Document object, POST its data into an existing Collection.

No fields are mandatory; however, if you provide `name` and/or `uid` we will make your Document accessable using these attributes. Otherwise we will generate the uid and name. We suggest you provide both `uid` and `name`: it will help you find your _Document_ again in your _Collection_.

The value for `uid` must be unique within a Collection.

<aside>
You cannot change a Document's <code>uid</code> once it's been created.
</aside>

### Endpoint
`POST /v2/collections/{CID}/document/`

Replace `{CID}` with a valid Collection ID.


## Show details of a Document
```shell
$ curl --request GET \
  --url 'https://api.ax-semantics.com/v2/documents/d731e27cdd234e5486f1f309cd344e51/' \
  --header 'Authorization: Token f763438dac31499ba9ee5fc850f4d420'
```

### Endpoint
`GET /v2/documents/{DID}/`

Replace `{DID}` with a valid Document ID.

## Update an existing Document
```shell
$ curl --request PATCH \
  --url 'https://api.ax-semantics.com/v2/documents/fd5886af005c4ed9a9f56f8c1aa7949b/' \
  --header 'Authorization: Token 6978b4e8bb464a0fae3f4c77166caf94' \
  --header 'Content-Type: application/json' \
  --data '{"name":"Fresh new name","sn":"644129804140"}'
```

### Endpoint
`PATCH /v2/documents/{DID}/`

Replace `{DID}` with a valid Document ID.

## Delete a Document
```shell
$ curl --request DELETE \
  --url 'https://api.ax-semantics.com/v2/documents/62e5c91175844887964c1a9a3f6af2c6' \
  --header 'Authorization: Token df3f37d1c6f948738391661c705e13df'
```

### Endpoint
`DELETE /v2/documents/{DID}/`

Replace `{DID}` with a valid Document ID.


## Generate content for a single Document
```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/documents/dca2b1cac20249edaaeb5db305362636/generate-content/' \
  --header 'Authorization: Token 9a06ea87078d4129be35262a868abc29'
```

### Endpoint
`POST /v2/documents/{DID}/generate-content`

Replace `{DID}` with a valid Document ID.
