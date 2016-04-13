---
title: AX Semantics API Reference

language_tabs:
  - shell
  - python

toc_footers:
  - <a href='https://www.ax-semantics.com/'>more about the AX NLG Cloud</a>
  - <a href='https://my.ax-semantics.com/#/account/sign-up'>register on myAX - Self Service Portal</a>
  - <a href="https://github.com/axsemantics/api-docs/">Source on Github</a>

search: true
---

# Introduction to the myAX API

## Basics
The myAX web application (`my.ax-semantics.com`) is a self-service portal integrated in the AX NLG Cloud. It enables your access to functionality such as data transfer, text generation and integration of automated content generation into your website.

**All functionality of the platform is accessible via our API** at `api.ax-semantics.com` to ensure an easy integration into other platforms and systems.

## Terms and Definitions
* _Objects_ (aka Things) are data nodes containing information from which a text can be generated
* _Content Projects_ are collections of similar Objects combined with a text engine training and an engine configuration which includes the desired keyword density, text length, language etc.
* A _Training_ is an interpretative ruleset for the AX Text-Engine, to derive information from data and transfer this information into natural language. Trainings are always dependent on a certain data structure.
* A _Content generation request_ is a request sent to the NLG Cloud to produce a text out of an Object based on the underlying training. The generated content is realized through an asynchronous process and is attached to the object after successful text generation.


# Authentication
The API requires the input of an "Authorization header". The value will be relayed to you after your login.

The header should look like this:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

You have to exchange `aa5d2e36668c11e5964038bc572ec103` for your own API token.

## Login
```python
import axsemantics

try:
    axsemantics.login(user='USER@EXAMPLE.COM', password='SECRET_PASSWORD')
    print(axsemantics.constants.API_TOKEN)

except axsemantics.AuthenticationError:
    pass
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"email":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
```

> The API returns a JSON string such as:

```json
{"key":"aa5d2e36668c11e5964038bc572ec103"}
```

You will receive your token as response to your login request.

### Endpoint
`POST /v1/rest-auth/login/`



# Objects
Your data input is saved as objects, regardless of their old format. These Objects are always attached to a Content Project.

## Create new objects
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

### Notes on pure_data
Depending on the shell you're using, you may need to escape quotation marks in the JSON-String for the pure_data field. In the example call on a cURL shell the quotation marks are escaped with a backslash prefix.

Additionally, please take care of the data types in your json structure. Non-number formats like `"somekey":010` will result in errors, and may need to be put into double ticks (`"somekey":"010"`) or converted to a number (`'"somekey":10`). This will result in errors messages like `{"detail":"JSON parse error - Expecting ',' delimiter: line 1 column 9 (char 8)"}`.

### Endpoint
`POST /v1/content-project/{CP_ID}/thing/`

In the example you have to exchange `{CP_ID}` with a valid content project id.

## Update an existing Object
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

### Endpoint
`PUT /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the object ID assigned by the platform!*.

## Delete an Object
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1).get(123)
thing = cp.things.all().get(id=2)
thing.delete()
```

```shell
$ curl --request DELETE \
  --url https://api.ax-sementics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

### Endpoint
`DELETE /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the object ID assigned by the platform!*.

## Get more information about Object properties

Sometimes you might require more details on object properties (like units in a field like `width`). This endpoint will
return a description of properties including a help text, their requirement level and the expected type.

```shell
$ curl --request OPTIONS \
  --url https://api.ax-sementics.com/v1/content-project/1/thing/ \
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

### Endpoint
`OPTIONS /v1/content-project/{CP_ID}/thing/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

# Generating Content
The content generation through the API is accessible when all mandatory information is present in the object.

## Generate content for a single Object
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
thing = cp.things().get(id=334)
response = thing.generate_content(force=False)
```

```shell
$ curl --request POST \
  --url "https://api.ax-semantics.com/v1/content-project/1/thing/123/generate_content/?force=true" \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The response contains informations regarding the content request, such as:

```json
{ "status": "CALLED",
  "number": 1,
  "content_request": {
    "id": 123,
    "content_project": 1,
    "generated_text_in_html": null,
    "thing_type": "demo",
    "state": "Started",
    "created": "2015-10-02T11:56:45.994940Z",
    "modified": "2015-10-02T11:56:46.068082Z",
    "...":"..." }}
```

### Endpoint
`POST /v1/content-project/{CP_ID}/thing/{OBJ_ID}/generate_content/{force}`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the object ID assigned by the platform!*.

`{force}` is a query parameter which is used to define whether the Content Request should discard and regenerate existing content. This parameter is optional, the default is **force=false**.

- **?force=false** (default): Content will be requested if this object has no existing content. Otherwise no action is taken.
- - **?force=true**: Existing content will be discarded and regenerated.

## Generate content for a whole Content Project
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
response = cp.generate_content(force=False)
```

```shell
$ curl --request POST \
  --url "https://api.ax-semantics.com/v1/content-project/2123/generate_content/?force=true" \
  --header "Authorization: Token aa5d2e36668c11e5964038bc572ec103"
```

> The API responds by returning a JSON response, such as:

```json
{"status":"CALLED","number":3}
```
### Endpoint
`POST /v1/content_project/{CP_ID}/generate_content/{force}`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

`{force}` is a query parameter which is used to define whether the content request should discard and regenerate existing content. This parameter is optional, the default is **force=false**.

## Request status report for a content request
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
thing = cp.things().get(id=334)
thing['status']
```

```shell
$ curl --request GET \
    --header "Authorization: Token aa5d2e36668c11e5964038bc572ec103" \
    --url "https://api.ax-semantics.com/v1/content-project/1/thing/123/"
```

> The API response includes a status field:

```json
{ "id": 123,
  "uid": "demo",
  "status": "not requested",
  "generated_text": null,
  "content_project": 1,
  "...":"..." }
```

### Endpoint
`GET /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the ID assigned by the platform!*.

## Export generated content for a single Object
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
thing = cp.things().get(id=334)
thing['generated_text']
thing['text_as_html']
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns information regarding the Object, including generated text if any exists:

```json
{ "id": 456,
  "content_project": 1,
  "state": "Success",
  "generated_text_in_html": "<h1>Überschrift</h1>\n<p>Absatz</p>",
  "generated_text": "# Überschrift\nAbsatz",
  "...": "..." }
```

The generated content is available in its original format or in HTML-format. Usually the original format is [Markdown](https://daringfireball.net/projects/markdown/syntax/).

### Endpoint
`GET /v1/content-project/{CP_ID}/thing/{OBJ_ID}/content_request/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID and `{OBJ_ID}` with a valid Object ID. *Keep in mind that this is not the UID but the ID assigned by the platform!*.

## Push for new content via web hooks

On request, we can activate the push feature for new content: When a new text is generated MyAX will send a HTTP POST request to the web hook URL.

It has a signature header to verify the integrity/authenticity and some data about the object and the text in the post data body.

### Signature header

```
HTTP_X_MYAX_SIGNATURE: "sha1=df589122eac0f6a7bd8795436e692e3675cadc3b"
```

The checksum is calculated as hmac sha1 hexdigest. The key is your API token. The message is the post data.

### POST data

You will receive POST data looking like this:

```
{
  "id": 9001,
  "name": "<The name of the object>",
  "text": "<The new text (raw)>",
  "text_as_html": "<The new text (as html from markdown)>",
  "uid": "<The uid you put in the object>",
  "content_project_name": "<Name of the content project>",
  "content_project_id": 1337,
  "text_modified": "2015-10-21T23:29:00.000000+00:00",
  "language": "en-US"
}
```




## Export generated content for an entire Content Project

If you want to have the content available as one big download file, you can use the export functionality.

```python
Coming soon.
```

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/download-exports/?page=1&page_size=10'
  # yields a list of available downloads
  # find your required download and use its 'download_url' attribute
$ curl --request GET \
  --output export.xlsx \
  --url https://api.ax-semantics.com/v1/content_project_export_download/7f9cc6a2-6b55-11e5-bb84-5e2c2d9baef2
```
### Endpoint
`GET /v1/download-exports/`


# Autoprocessing

## Autoprocessing for bulkuploads
```python
Coming soon.
```

```shell
$ curl --request POST \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url https://api.ax-semantics.com/v1/bulkupload/ \
  --form 'tag=demo' \
  --form 'content_project=1' \
  --form 'data_file=@/home/user/Desktop/demofile.xlsx;filename=demofile.xlsx' \
  --form 'autoprocess=true'
```
By using Autoprocessing your content will be automatically generated and prepared for download.

The Autoprocessing function is triggered if you use the checkbox during a bulkupload. Your data will then be imported into a content project. Afterwards the content will be generated for all imported objects and made available as a file in your account. You are informed by email when your content is available.

## Autoprocessing for new Objects
On request, your Content Project can be configured for "automatic processing". For any new objects, a text generation request is then triggered automatically once, saving you the call to request the content.


### Endpoint
`POST /v1/bulkupload/`

# Content Projects
Content Projects are collections of objects, coupled with an engine configuration and an engine training. The data that is used to generate content is deposited into objects. The Framework and interpretational ruleset for the text creation is represented by the engine training. Lastly meta information like language and data type is provided by the chosen engine configuration.

## List Content Projects
```python
import axsemantics
axsemantics.login('', '')

cp_list = axsemantics.ContentProjects.all()
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns a JSON string, such as:

```json
{ "count": 1,
  "next": null,
  "previous": null,
  "results": [ { "id": 1,
      "name": "Test",
      "keyword_deviation": "33.00",
      "keyword_density": "3.00",
      "max_length": 0,
      "axcompany": 20,
      "axcompany_name": "Ihre Firma",
      "engine_configuration": 1,
      "count_things": 1,
      "count_generated_texts": 0,
      "min_length": null,
      "count_generated_texts_errors": 0 } ] }
```

### Endpoint
`GET /v1/content-project/`

## List a single Content Project
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject.all().get(id=1)
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/1/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns a JSON response, such as:

```json
{ "id": 1,
  "name": "Test",
  "keyword_deviation": "33.00",
  "keyword_density": "3.00",
  "max_length": 0,
  "axcompany": 20,
  "axcompany_name": "Ihre Firma",
  "engine_configuration": 1,
  "count_things": 1,
  "count_generated_texts": 0,
  "min_length": null,
  "count_generated_texts_errors": 0 }
```

### Endpoint
`GET /v1/content-project/{CP_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.


### Access generated content 

To get your generated content, all things with their content can be listed as follows:

`GET /v1/content-project/{CP_ID}/thing/`

* This gives you the data to identify the thing and the generated text.
* the field `generated_text` contains the text (with markdown) and `text_as_html` contains the same content converted to HTML 
* This endpoint uses pagination, the URLs for `next`/`previous` page are provided by the API in the respective fields.

```
{
    "count": 164,
    "next": "https://api.ax-semantics.com/v1/content-project/3992/thing/?page=2",
    "previous": null,
    "results": [
        {
            "id": 1637938,
            "generated_text": "Mit einem leichten Plus von 0,36 % schloss die Pearson plc-Aktie heute bei 700,5 GBP. Im Vergleich zum Vortag stieg die Aktie um 0,94 % (6,5 GBP). Im Vergleich zum Vorjahr fiel sie um -38,51 % (-438,72 GBP).",
            "status": "success",
            "error_msg": "",
            "most_important_missing_requirement_level": 0,
            "requirement_level_status_text": "Data quality for this object is satisfactory.",
            "is_content_generation_available": true,
            "created": "2016-01-14T06:24:23.221964Z",
            "modified": "2016-01-14T06:50:06.152555Z",
            "uuid": "35963a99-8849-4f0d-87d6-1e8e6ce70b73",
            "uid": "7207909",
            "alternate_name": null,
            "description": null,
            "name": "Pearson plc [LSE] (2016-01-13)",
            "url": null,
            "tag": null,
            "_text": "Mit einem leichten Plus von 0,36 % schloss die Pearson plc-Aktie heute bei 700,5 GBP. Im Vergleich zum Vortag stieg die Aktie um 0,94 % (6,5 GBP). Im Vergleich zum Vorjahr fiel sie um -38,51 % (-438,72 GBP).",
            "text_as_html": "<p>Mit einem leichten Plus von 0,36 % schloss die Pearson plc-Aktie heute bei 700,5 GBP. Im Vergleich zum Vortag stieg die Aktie um 0,94 % (6,5 GBP). Im Vergleich zum Vorjahr fiel sie um -38,51 % (-438,72 GBP).</p>",
            "text_modified": "2016-01-14T06:50:06.152029Z",
            "text_state": "SUCCESS",
            "text_error_msg": null,
            "text_duration": 1542838,
            "text_metrics": "{\n  \"text_length_in_words\": 57,\n  \"text_length_in_chars\": 207\n}",
            "stock_code": "PSON.L",
            "stock_name": "Pearson plc",
            "stock_exchange": "LSE",
            "stock_type": "stock",
            "category_name": "Publishing - Newspapers",
            "date": "2016-01-13",
            "content_project": 3992
        },
```




## Create new Content Project
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject(name='new cp', engine_configuration=123)
cp.create()
```

```shell
$ curl --request POST \
  --url https://api.ax-sementics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --header 'Content-type: application/json' \
  --data '{"name":"neues cp","engine_configuration":123}'
```

> The API returns a JSON response, such as:

```json
{ "id": 42,
  "name": "neues cp",
  "keyword_deviation": "33.00",
  "keyword_density": "3.00",
  "max_length": null,
  "axcompany": 20,
  "axcompany_name": "Ihre Firma",
  "engine_configuration": 123,
  "count_things": 0,
  "count_generated_texts": null,
  "min_length": null,
  "count_generated_texts_errors": null }
```

### Endpoint
`POST /v1/content-project/`

Mandatory information to create a new content project:

 - **name**: a sufficiently descriptive name of your content project (string)
 - **engine_configuration**: The ID of the suitable Engine Configuration (integer). This ID is visible in the API endpoint "Engine Configuration".

Optional information for your content project:

 - **keyword_deviation**: decimal, e.g.: '33.0'
 - **keyword_density**: decimal, e.g.: '3.0'

## Filter and search for Content Projects

## Delete Content Projects
```python
import axsemantics
axsemantics.login('', '')

axsemantics.ContentProject.all().get(id=1).delete()
```

```shell
$ curl --request DELETE \
  --url https://api.ax-sementics.com/v1/content-project/1/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> The API responds with a '204 NO CONTENT' status.

### Endpoint
`DELETE /v1/content-project/{CP_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

<aside class="warning">
In the event of deleting a content project ALL Objects and generated content is also deleted! The API does not ask for conformation, but immediately executes the request!
</aside>

# Actions affecting multiple Content Projects

Some actions are executable for objects regardless of their affiliation to a content project.

## Display Objects from different Content Projects
```python
Coming soon.
```
```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/allthings/?ordering=-modified&page=1&page_size=30&tag=KW+23'
  # die Objekte unter dem Schlüsselwort 'things' auswerten
  # beispielhafter Aufruf für nur ein Objekt
  curl --request POST \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/content_project/1/thing/123/generate_content/?force=true
```

> The API responds with a JSON string, such as:

```json
{ "next_link": "https://api.ax-semantics.com/v1/allthings/?page=2",
  "count": 2,
  "ordering": "-modified",
  "next": 2,
  "page": 1,
  "results": [ {
      "id": 9001,
      "uid": "123",
      "uuid": "ea9cebc6-6c40-11e5-bd8e-3d122d9baef2",
      "name": "demoteil",
      "status": "success",
      "thing_type": "demo",
      "content_project_pk": 1,
      "...": "..." } ] }
```

Please keep in mind that the field `id` doesn't necessarily have a one-to-one relation in this view. To establish this relation combine the fields `id` and `content_project_pk` or use the field `uuid` for reference.

### Endpoint
`GET /v1/allthings/`


# Example use cases

## Generate content from existing data
```python
Coming soon.
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"email":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
$ curl --request POST \
  --url "https://api.ax-semantics.com/v1/content-project/2123/generate_content/?force=true" \
  --header "Authorization: Token aa5d2e36668c11e5964038bc572ec103"
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/download-exports/?page=1&page_size=10'
  # ergibt Liste von möglichen Downloads, die analysiert werden müssen. Die
  # relevante Information findet sich unter dem Schlüsselwort "download_url"
$ curl --request GET \
  --output export.xlsx \
  --url https://api.ax-semantics.com/v1/content_project_export_download/7f9cc6a2-6b55-11e5-bb84-5e2c2d9baef2
```

To generate content for already imported data (in this example, a complete content project), follow these steps:

1. **Get your authentication token:** Use your existing login information (email and password). This authentication token will be used in all further step to authenticate you with the API. (Every API client will do this for you.)
2. **Determine the Content Project ID:** If you do not know the ID of your chosen Content Project, request the list of all Content Projects and look at its entries to determine the Content Project ID.
3. **Generate content for the whole Content Project:** Refer to the Content Project by the ID you determined in step **2**.
4. [Optional] **Request status of content generation until it is finished:** this is mostly relevant for larger requests. You need to use both the Content Project ID and a Thing ID here.
5. **Download the generated content:** Find the appropriate Download URL for the generated content and request the download.

## Import data, then generate content
```python
import axsemantics

axsemantics.login('', '')

data = {'key':'value'}
thing = axsemantics.Thing(uid=1, cp_id=1, pure_data=data, name='demo').create()
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"email":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data":"{\"key\":\"value\"}"}'
$ curl --request PUT \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data":"{\"diffent key\":\"different value\"}"}'
```

If you have an existing Content Project, but you need to import data before content generation, follow these steps and then continue at the example for content generation above.

1. **Get your authentication token:** Use your existing login information (email and password). This authentication token will be used in all further step to authenticate you with the API. (Every API client will do this for you.)
2. **Determine the Content Project ID:** If you do not know the ID of your chosen Content Project, request the list of all Content Projects and look at its entries to determine the Content Project ID.
3. **Create a new Object with your data:** Within that Content Project, you can now create new objects. The data you want to import should be sent in the `pure_data` field. You will give the Object an UID. However, if you need to look up or address the Object later on, you need to save the returned Object ID.
4. [Optional] **Update an Object's data:** Sometimes, you want to update an Object's data. Here you will have to use the generated Object ID (instead of the UID of your choosing) to address the Object.
