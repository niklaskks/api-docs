---
title: AX Semantics API Referenz

language_tabs:
  - shell
  - python

toc_footers:
  - <a href='https://www.ax-semantics.com/'>mehr über AX NLG Cloud</a>
  - <a href='https://my.ax-semantics.com/#/account/sign-up'>auf dem myAX - Self Service Portal registrieren</a>
  - <a href="https://github.com/axsemantics/api-docs/">Quellcode auf Github</a>

search: true
---

# Introduction
The myAX web application (`my.ax-semantics.com`), as a self-service portal integrated in the AX NLG Cloud, enables your acces to functionalities like data transfer, text generation and integration of automated content generation into your website.

**All functionalities are accesible via an API** (`api.ax-semantics.com`), to ensure an easy integration into other platforms and it systems.

## terms and definitions
* _Objects_ (aka. Things) are data nodes containing certain informations from which a text can be individually generated 
* _Content Projects_ are a pool of similar Objects combined with a text engine training and an engine configuration whitch includes the desired keyword density, textlength, language, etc.
* A _Training_ is an interpretative Ruleset for the AX Text-Engine, to derive information from data and transfer this information into natural language. Trainings are allways dependent on a certain datastructure.
* A _Content generation_ is a request send to the NLG Cloud, to produce a story out of an Object based on the underlying training. The generated content is realized through an asynchronous process and is attached to the object after successfull text generation.



# Authentication
The API requires the input of an "Authorization header". The value will be relayed to you after your login.

The header should look like this:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

You have to exchange `aa5d2e36668c11e5964038bc572ec103` for your own API token.

## Login
```python
import axsemantics

api = axsemantics.login('USER@EXAMPLE.COM', 'SECRET_PASSWORD')
print(api.token)
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"username":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
```

> The API returns a JSON file such as:

```json
{"key":"aa5d2e36668c11e5964038bc572ec103"} 
```

After you have logged in you can view your token in the API response.

### Endpoint
`POST /v1/rest-auth/login/`

# Objects
Your data input is saved as objects, regardless of their old format. These Objects are allways attached to a content project.

## Create new objects
```python
import axsemantics
api = axsemantics.login('', '')

data = {'key':'value'}
obj = api.content_project.get(1).create(uid=1, name='demo', pure_data=data)
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data":"{\"key\":\"value\"}"}'
```

To create a new object, POST its data into an existing content project. Please add the ID of the existing content project into your POST URL.

Mandatory information for the creation of an object are:

 - **uid**: String containing arbitrary content; the primary mean of identifying your objects
 - **name**: String containing arbitrary content; the textual identifier of the object
 - **content_project**: Integer; states the Content Project which contains this object
 - **pure_data** (nur bei entsprechenden Projekten): JSON
 
Depending on the type of content the object may need other mandatory information.

### notes on pure_data
Depending on the shell you're using, you may need to escape quotation marks in the JSON-String for the pure_data field. In the example call on a cURL shell the quotation marks are escaped with a backslash prefix. 

### Endpoint
`POST /v1/content-project/{CP_ID}/thing/`

In the example you have to exchange `{CP_ID}` with a valid content project id.

## update an existing object
```python
import axsemantics
api = axsemantics.login('', '')

obj = api.content_project.get(1).get(123)
obj.pure_data = {'different key':'different value'}
obj.save()
```

```shell
$ curl --request PUT \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data":"{\"diffent key\":\"different value\"}"}'
```

### Endpoint
`PUT /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid content project id and `{OBJ_ID}` with a valid object id. *Keep in mind that this is not the UID but the object ID given by the platform!*.

## delete an existing object
```python
import axsemantics
api = axsemantics.login('', '')

obj = axsemantics.content_project.get(1).get(123)
obj.delete()
```

```shell
$ curl --request DELETE \
  --url https://api.ax-sementics.com/v1/content-project/1/thing/123/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

### Endpoint
`DELETE /v1/content-project/{CP_ID}/thing/{OBJ_ID}/`

In the example you have to exchange `{CP_ID}` with a valid content project id and `{OBJ_ID}` with a valid object id. *Keep in mind that this is not the UID but the object ID given by the platform!*.

# Generating Content
The content generation through the API is accessible, when all the mandatory information is present in the object.

## Generate content for a single object
```python
import axsemantics
api = axsemantics.login('', '')

obj = axsemantics.content_project.get(1).get(123)
obj.generate_content(force=True)
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/generate_content/?force=true \
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

In the example you have to exchange `{CP_ID}` with a valid content project id and `{OBJ_ID}` with a valid object id. *Keep in mind that this is not the UID but the object ID given by the platform!*.

`{force}` is a query parameter which is used to define wether the content request should discard and regenerate existing content. This parameter is optional: If you didn't use the force parameter the default action is **force=false**.

- **?force=false** (default): content is requested if this object has no existing content. Otherwise no action is taken. 
- - **?force=true**: existing content will be discarded and regenerated

## Generate content for a whole content project
```python
import axsemantics
api = axsemantics.login('', '')

success, count = api.content_project.get(1).generate_content(force=True)
if success:
    print('Started content generation for {} objects'.format(count))
```

```shell
$ curl --request POST \
  --url "https://api.ax-semantics.com/v1/content-project/2123/generate_content/?force=true" \
  --header "Authorization: Token aa5d2e36668c11e5964038bc572ec103"
```

> The API responds by returning a JSON file, such as:

```json
{"status":"CALLED","number":3}
```
### Endpoint
`POST /v1/content_project/{CP_ID}/generate_content/{force}`

In the example you have to exchange `{CP_ID}` with a valid content project id.

`{force}` is a query parameter which is used to define wether the content request should discard and regenerate existing content. This parameter is optional: If you didn't use the force parameter the default action is **force=false**.

## Request status report for a content request
```python
import axsemantics
api = axsemantics.login('', '')

obj = api.content_project.get(1).get(123)
if obj.status:
    print('Content for this object has already been requested.')
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

In the example you have to exchange `{CP_ID}` with a valid content project id and `{OBJ_ID}` with a valid object id. *Keep in mind that this is not the UID but the object ID given by the platform!*.

## Export generated conted for a single object
```python
import axsemantics
api = axsemantics.login('', '')

content = api.content_project.get(1).get(123).content
print(content.text_html)
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/123/content_request/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns information regarding the Content Request, such as:

```json
{ "id": 456,
  "content_project": 1,
  "state": "Success",
  "generated_text_in_html": "<h1>Überschrift</h1>\n<p>Absatz</p>",
  "generated_text": "# Überschrift\nAbsatz",
  "error_msg": null,
  "...": "..." }
```

The generated content is available in its original format or in HTML-format. Usually the original format is [Markdown](https://daringfireball.net/projects/markdown/syntax/).

### Endpoint
`GET /v1/content-project/{CP_ID}/thing/{OBJ_ID}/content_request/`

In the example you have to exchange `{CP_ID}` with a valid content project id and `{OBJ_ID}` with a valid object id. *Keep in mind that this is not the UID but the object ID given by the platform!*.

## Export generated conted for an entire content project
```python
import axsemantics
api = axsemantics.login('', '')

cp = api.content_project.get(1)
download = api.download_exports.filter(content_project=cp).first()
with open('exports.xlsx', mode='wb') as f:
    f.write(download)  # nun kann man die Datei z.B. in Excel öffnen
```

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/download-exports/?page=1&page_size=10' 
  # ergibt Liste von möglichen Downloads, die analysiert werden müssen. Die
  # relevante Information findet sich unter dem Schlüsselwort "download_url"
$ curl --request GET \
  --output export.xlsx \
  --url https://api.ax-semantics.com/v1/content_project_export_download/7f9cc6a2-6b55-11e5-bb84-5e2c2d9baef2
```
### Endpoint
`GET /v1/download-exports/`


# Autoprocessing
```python
import axsemantics
api = axsemantics.login('', '')

cp = api.content_project.get(1)
axsemantics.bulkupload(content_project=cp, tag='demo',
    file='/home/user/Desktop/demofile.xlsx', autoprocess=True)
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
By using Autoprocessing youre content gets automatically generated and prepared for download. 

The Autoprocessing function is triggered if you use the checkbox during a bulkupload. Your Date is then imported into a content project. After that the content is generated for all imported objects and packed into a downloadable file in your account. You are informed by email when your content is available.

### Endpoint
`POST /v1/bulkupload/`

# Content Projects
"Content Projects" are an interplay of objects, an engine configuration and an engine training. The data that is used to generate content is deposited into objects. The Framework and interpretational ruleset for the text creation is represented by the engine training. Lastly meta information like language and data type is provided by the chosen engine configuration.

## List content projects
```python
import axsemantics
api = axsemantics.login('your', 'credentials')

cp_list = api.content_projects.all()
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns a JSON file, such as:

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

## List a single content project
```python
import axsemntics
api = axsemantics.login('', '')

cp = axsemantics.content_projects.get(1)
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/1/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103'
```

> The API returns a JSON file, such as:

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

In the example you have to exchange `{CP_ID}` with a valid content project id.

## Creat new content project
```python
import axsemantics
api = axsemantics.login('', '')

cp = axsemantics.content_project.create(name='neues cp', engine_configuration=123)
```

```shell
$ curl --request POST \
  --url https://api.ax-sementics.com/v1/content-project/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --header 'Content-type: application/json' \
  --data '{"name":"neues cp","engine_configuration":123}'
```

> The API returns a JSON file, such as:

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

Mandatory information to creat a new contentproject: 

 - **name**: a sufficiently descriptive name of your content project, formated as a string
 - **engine_configuration**: The ID of the suitable Engine Configuration, formated as an Integer. This ID is visible in the API endpoint "Engine Configuration".
 
Optional information for your contentproject:

 - **keyword_deviation**: decimal, e.g.: '33.0'
 - **keyword_density**: decimal, e.g.: '3.0'

## filter and search for content projects

## Delete content projects
```python
import axsemantics
api = axsemantics.login('', '')

api.content_project.get(1).delete()
```

```shell
$ curl --request DELETE \
  --url https://api.ax-sementics.com/v1/content-project/1/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> The API returns a '204 NO CONTENT'-message.

### Endpoint
`DELETE /v1/content-project/{CP_ID}/`

In the example you have to exchange `{CP_ID}` with a valid content project id.

<aside class="warning">
In the event of deleting a content project ALL objects and generated content is also deleted! The API does not ask for conformation, but immidately executes the request!
</aside>

# Actions which affect multiple content projects

Some actions are executable for objects regardless of their affiliation to a content project.

## Display objects from different content projects
```python
import axsemantics
api = axsemantics.login('', '')

for each_obj in api.allthings(tag='KW23'):
    if not each_obj.status:
        each_obj.generate_content()
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

> The API responds a JSON file, such as:

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

Please keep in mind that the field `id` doesnt necessesarily have a one-to-one relation in this view. To establish this relation combine the fileds `id` and `content_project_pk` or use the field `uuid` for reference.

### Endpoint
`GET /v1/allthings/`


&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
  

# Example use cases

## Generate content from existing data
```python
import axsemantics

api = axsemantics.login('USER@EXAMPLE.COM', 'SECRET_PASSWORD')
cp_list = api.content_projects.all()
cp = cp_list[INDEX]
success, count = cp.generate_content(force=True)
download = api.download_exports.filter(content_project=cp).first()
with open('exports.xlsx', mode='wb') as f:
    f.write(download)  # nun kann man die Datei z.B. in Excel öffnen
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"username":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
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

1. **Get your authentication token:** Use your existing login information (username and password). This authentication token will be used in all further step to authenticate you with the API. (Every API client will do this for you.)
2. **Determine the Content Project ID:** If you do not know the ID of your chosen Content Project, request the list of all Content Projects and look at its entries to determine the Content Project ID.
3. **Generate content for the whole Content Project:** Refer to the Content Project by the ID you determined in step **2**.
4. [Optional] **Request status of content generation until it is finished:** this is mostly relevant for larger requests. You need to use both the Content Project ID and a Thing ID here.
5. **Download the generated content:** Find the appropriate Download URL for the generated content and request the download.

## Import data, then generate content
```python
import axsemantics

api = axsemantics.login('USER@EXAMPLE.COM', 'SECRET_PASSWORD')
cp_list = api.content_projects.all()
cp = cp_list[INDEX]
data = {'key':'value'}
obj = api.content_project.get(1).create(uid=1, name='demo', pure_data=data)
obj = api.content_project.get(1).get(123)
obj.pure_data = {'different key':'different value'}
obj.save()
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"username":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
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

If you have an existing Content Project, but you need to import data before conent generation, follow these steps and then continue at the example for content generation above.

1. **Get your authentication token:** Use your existing login information (username and password). This authentication token will be used in all further step to authenticate you with the API. (Every API client will do this for you.)
2. **Determine the Content Project ID:** If you do not know the ID of your chosen Content Project, request the list of all Content Projects and look at its entries to determine the Content Project ID.
3. **Create a new Object with your data:** Within that Content Project, you can now create new objects. The data you want to import should be sent in the `pure_data` field. You will give the Object an UID. However, if you need to look up or address the Object later on, you need to save the returned Object ID.
4. [Optional] **Update an Object's data:** Sometimes, you want to update an Object's data. Here you will have to use the generated Object ID (instead of the UID of your choosing) to address the Object.
