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


### Pull Content from API
* if you want to filter on all succesfull text generations, you can add `?text_state=SUCCESS` to `/thinglist/`
`https://api-stage.ax-semantics.com/v1/content-project/3745/thinglist/?text_state=SUCCESS`





## Create new Content Project
```python
import axsemantics
axsemantics.login('', '')

cp = axsemantics.ContentProject(name='new cp', engine_configuration=123)
cp.create()
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/ \
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
  --url https://api.ax-semantics.com/v1/content-project/1/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> The API responds with a '204 NO CONTENT' status.

### Endpoint
`DELETE /v1/content-project/{CP_ID}/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

<aside class="warning">
In the event of deleting a content project ALL Objects and generated content is also deleted! The API does not ask for conformation, but immediately executes the request!
</aside>


## Empty a Content Project

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/empty/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> The API returns status code '202 ACCEPTED' and a JSON messges such as:

```json
{"message": "Started emptying ContentProject (1/neues cp)"}
```

### Endpoint
`POST /v1/content-project/{CP_ID}/empty/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.

<aside class="warning">
This will delete all objects and generated content for the given Content Project. The API does not ask for confirmation,  but immediately executes the request!
</aside>


## Clone a Content Project

Creates a new Content Project for you. It will copy Objects from the original to the new Content Project. These Objects will be seperate entities with their own IDs but otherwise same properties.

Cloning is done asynchrounosly: the new Content Project will show up in your list after a while (depending on its size).


```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/clone/ \
  --header 'Authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> The API returns '202 ACCEPTED' if the given Content Project could be cloned; otherwise it returns a '404 NOT ALLOWED'.

### Endpoint
`POST /v1/content-project/{CP_ID}/clone/`

In the example you have to exchange `{CP_ID}` with a valid Content Project ID.


# Actions affecting multiple Content Projects

Some actions are executable for objects regardless of their affiliation to a content project.

## Display Objects from different Content Projects

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

