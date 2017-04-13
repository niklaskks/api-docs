# v2 API
<aside>
The v2 API is our current API. Use this if you are using the [NLG Cloud Cockpit](https://cockpit.ax-semantics.com).
If you are migrating from v1 API: Documents replace "Things" from v1, Collections replace "Content Projects".
</aside>

# Documents
We store your data in Documents.

* Each Document belongs to exactly one Collection.
* Each item that you want to write about needs to have its separate document, containing all the data that is needed
  to write about that item.

## Data Intake: Add a new Document

```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/collections/1/document/' \
  --header 'Authorization: Token 7de3adb043d74ca79de98cc5b6d7c405' \
  --header 'Content-Type: application/json' \
  --data '{"uid": 222333,"name":"demo","capacity":{"unit":"F","value":4"}}'
```

To upload your data, create one Document object per item. Before doing so you have to use the GUI to set up the collection these Documents will belong to. Note the ID the new collection is assigned – this ID needs to be put into the API call.

To create a new Document object, POST its data into an existing Collection as JSON.

No fields are mandatory; however, if you provide `name` and/or `uid`, we will make your Document accessible using these
attributes. Otherwise we will generate the uid and name. We suggest you provide both `uid` and `name`: it will help you
find your Document again.

If you are not providing the fields uid or name, we will try to find one of the following keys: 'id', 'uid', 'sku',
'Artikelnummer' for the `id` field, and 'NAME', 'Name', 'Produktname','produktname', 'Artikel', 'article' for the
`name` field. If none of these are present, we will generate the uid and name. 

The value for `uid` must be unique within a Collection. This uniqueness criteria also applies if your uid field is
taken from one of the fallback keys mentioned above.

<aside>
You cannot change a Document's `uid` once it has been created.
</aside>

### Endpoint
`POST /v2/collections/{CID}/document/`

Replace `{CID}` with a valid Collection ID.

## List all documents of a collection

```shell
$ curl --request GET \
  --url 'https://api.ax-semantics.com/v2/documents/?collection=11' \
  --header 'Authorization: Token f763438dac31499ba9ee5fc850f4d420'
```

`GET /v2/documents/?collection={CID}`

Replace `{CID}` with a valid Collection ID.

## Text delivery
To get to your generated text from the API, request the list of all documents with finished texts:

`GET /v2/documents/?collection={CID}&processing_state=generated`

Replace `{CID}` with a valid Collection ID.

Hint on pagination: The API will return the items with a page size of 10, and includes a dynamic "next" object for
automatically retrieving the next documents.

```shell
$ curl --request GET \
  --url 'https://api.ax-semantics.com/v2/documents/?collection=11&processing_state=generated' \
  --header 'Authorization: Token f763438dac31499ba9ee5fc850f4d420'
```

For push delivery, set up a webhook address and shared secret in the GUI.


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

## Webhook for receiving text
### Push for new content via webhooks

In the Collection preferences, you can activate the push feature for new content: When a new text is generated our
system will send a HTTP POST request to the webhook URL.

The request will have a signature header to verify the integrity and authenticity. The request body will contain
metadata about the object and the generated text.

#### Signature header

```
HTTP_X_MYAX_SIGNATURE: "sha1=df589122eac0f6a7bd8795436e692e3675cadc3b"
```

The checksum is calculated as HMAC SHA1 hexdigest. The key is your API token. The message is the post data.

Please note that depending on the framework/language that is in use, the signature header can also be X-MYAX-SIGNATURE.

#### POST data

```
{
  "id": 9001,
  "name": "<The name of the object>",
  "text": "<The new text (raw)>",
  "text_as_html": "<The new text (as html from markdown)>",
  "uid": "<The uid you put in the object>",
  "collection_name": "<Name of the content project>",
  "collection_id": 1337,
  "text_modified": "2015-10-21T23:29:00.000000+00:00",
  "language": "en-US"
}
```

You will receive POST data formed like the JSON on the right.

#### Verification

See the examples on the right on how to verify the HMAC.

For more information about HMAC validation, consult the documentation for your programming language and framework of
choice.  E.g. for PHP documentation is available in the [manual](http://php.net/manual/en/function.hash-hmac.php).

```python
import hmac
import hashlib

def signature_valid(request, raw_data):
    try:
        secret = AX_API_TOKEN  ## your knowledge!!
        signature_header = request.META['HTTP_X_MYAX_SIGNATURE'].replace('sha1=', '')
        signature_content = hmac.new(
            key=secret.encode('utf-8'),
            msg=raw_data,   ## content of request
            digestmod=hashlib.sha1
        ).hexdigest()
    except AttributeError:
        pass
    except KeyError:
        pass
    except Exception:
        raise
    else:
        return bool(signature_header == signature_content)
    return False
```

```php
/* Works with PHP 5 >= 5.1.2 and PHP 7 */
$aHttpHead = isset($_SERVER) ? $_SERVER : [];
$sHttpBody = file_get_contents('php://input');
$sApiKey = '...';
$sSignature = NULL;

if(isset($aHttpHead['HTTP_X_MYAX_SIGNATURE'])) {
    $sSignature = $aHttpHead['HTTP_X_MYAX_SIGNATURE'];
} elseif(isset($aHttpHead['http_x_myax_signature'])) {
    $sSignature = $aHttpHead['http_x_myax_signature'];
}

if($sSignature !== NULL) {
    $sChecksum = hash_hmac('sha1', $sHttpBody, $sApiKey, FALSE);
    if($sSignature == 'sha1='.$sChecksum || $sSignature == $sChecksum) {
        if(($aData = json_decode($sHttpBody, TRUE))) {
            //...
        }
    }
}
```
