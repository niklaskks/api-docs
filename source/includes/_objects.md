# v1 API

Legacy API for Projects via my.ax-semantics.com

These API Endpoints and "Content Projects" are deprecated an will be removed Q3/2017. Please do not use them to start new projects anymore.
Instead, use our new v2 API, with Documents and Collections.


## Objects
Your data input is saved as objects, regardless of their old format. These Objects are always attached to a Content Project.

### Create new objects
```python
import axsemantics
axsemantics.login('', '')

data = {'key':'value'}
cp = axsemantics.ContentProject.all().get(id=1)
thing = axsemantics.Thing(uid=1, name='demo', pure_data=data, cp_id=cp['id']).create()
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --header 'Content-Type: application/json' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data": {"key":"value"}}'
```

To create a new object, POST its data into an existing content project. Please add the ID of the existing content project into your POST URL as well as your request data.

Mandatory information for the creation of an object are:

 - `uid`: String containing arbitrary content; the primary means of identifying your objects
 - `name`: String containing arbitrary content; the textual identifier of the object
 - `content_project`: Integer; states the Content Project which contains this object
 - `pure_data` (if applicable): JSON

Depending on the type of content the object may need other mandatory information.

#### Notes on pure_data
Depending on the shell you're using, you may need to escape quotation marks in the JSON-String for the pure_data field. In the example call on a cURL shell the quotation marks are escaped with a backslash prefix.

Additionally, please take care of the data types in your JSON structure. Non-number formats like `"somekey":010` will result in errors, and may need to be put into double ticks (`"somekey":"010"`) or converted to a number (`'"somekey":10`). This will result in errors messages like `{"detail":"JSON parse error - Expecting ',' delimiter: line 1 column 9 (char 8)"}`.

#### Endpoint
`POST /v1/content-project/{CP_ID}/thing/`

In the example you have to exchange `{CP_ID}` with a valid content project id.

### Update an existing Object
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
thing = cp.things.all().get(123)
thing['pure_data'] = {'different key':'different value'}
thing.save()
```

```shell
$ curl --request PUT \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --header 'Content-Type: application/json' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data": {"diffent key":"different value"}}'
```

#### Endpoint
`PUT /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the object ID assigned by the platform!*.

### Delete an Object
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1).get(123)
thing = cp.things.all().get(id=2)
thing.delete()
```

```shell
$ curl --request DELETE \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

#### Endpoint
`DELETE /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the object ID assigned by the platform!*.

### Get more information about Object properties

Sometimes you might require more details on object properties (like units in a field like `width`). This endpoint will
return a description of properties including a help text, their requirement level and the expected type.

```shell
$ curl --request OPTIONS \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

The response will be structured similar to this:

```json
{ "name": "Leaf Detail List",
  "renders":["application/json","text/html"],
  "parses":["application/json","application/x-www-form-urlencoded","multipart/form-data"],
  "actions":{"POST":{
    "uid":{
        "type":"string",
        "required":true,
        "read_only":false,
        "help_text":"A unique ID. Used for later references to this object.",
        "max_length":256,
        "requirement_level":3
    },
    "description":{
        "type":"string",
        "required":false,
        "read_only":false,
        "help_text":"A short description of the item.",
        "requirement_level":0
    }
  }}
}
```

#### Endpoint
`OPTIONS /v1/content-project/{CP_ID}/thing/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

