---
title: API Referenz

language_tabs:
  - shell
  - python

toc_footers:
  - <a href='https://my.ax-semantics.com/#/account/sign-up'>Kostenlos registrieren</a>
  - <a href="https://github.com/axsemantics/api-docs/">Quellcode auf Github</a>
  - <a href='http://github.com/tripit/slate'>Erstellt mit Slate</a>

includes:
  - errors

search: true
---

# Einführung und kurze Erläuterungen


# Authentication

### Endpoint
`POST /v1/rest-auth/login/`

Die API verlangt die Angabe eines sog. "Authorization headers". Der Wert wird
Ihnen nach Login übermittelt.'

Der Header sollte wie folgt aussehen:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

<aside class="notice">
Sie müssen <code>aa5d2e36668c11e5964038bc572ec103</code> durch Ihr persönliches Token ersetzen.
</aside>


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

> Die API gibt dabei beispielsweise folgendes JSON zurück:

```json
{"key":"3c019382668c11e5bb5feb0c65696656"} 
```

# Content Projekte

"Content Projekte" stellen jeweils die Trainings dar. Innerhalb der Content
Projekte sind die einzelnen Datensätze als Objekte abgelegt; die Objekte haben
jeweils den gleichen Datentyp.

## Content Projekte auflisten

### Endpoint
`GET /v1/content-project/`

```python
import axsemantics
api = axsemantics.login('your', 'credentials')

cp_list = api.content_projects.all()
```

```shell
$ curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/ \
  --header 'authorization: Token 3c019382668c11e5bb5feb0c65696656'
```

> Die API gibt beispielsweise folgendes JSON zurück:

```json
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
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
      "count_generated_texts_errors": 0
    }
   ]
}
```

## Ein bestimmtes Content Projekt anzeigen

### Endpoint
`GET /v1/content-project/{ID}/`

<aside class="notice">
Sie müssen `{ID}` durch die id des jeweiligen Content Projektes ersetzen.
</aside>

```python
import axsemntics
api = axsemantics.login('', '')

cp = axsemantics.content_projects.get(1)
```

```shell
curl --request GET \
  --url https://api.ax-semantics.com/v1/content-project/1/ \
  --header 'authorization: Token 3c019382668c11e5bb5feb0c65696656''
```

> Die API gibt beispielsweise folgendes JSON zurück:

```json
{
  "id": 1,
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
  "count_generated_texts_errors": 0
}
```

## Neues Content Projekt anlegen

### Endpoint
`POST /v1/content-project/`

Sie müssen folgende Felder angeben: 

 - `name`: der von Ihnen gewählte Name dieses Content Projekts, geben Sie hier einen String an
 - `engine_configuration`: Die ID der passenden Engine Configuration, dies muss ein Integer sein
 
Sie können folgende Felder angeben:

 - `keyword_deviation`: Dezimalzahl, z.B.: '33.0'
 - `keyword_density`: Dezimalzahl, z.B.: '3.0'
 

```python
import axsemantics
api = axsemantics.login('', '')

cp = axsemantics.content_project.create(name='neues cp', engine_configuration=123)
```

```shell
curl -X POST https://api.ax-sementics.com/v1/content-project/ \
     -H 'Authorization: Token 3c019382668c11e5bb5feb0c65696656' \
     -H 'Content-type: application/json' \
     -d '{"name":"neues cp","engine_configuration":123}'
```

> Die API gibt beispielsweise folgendes JSON zurück:

```json
{
  "id": 42,
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
  "count_generated_texts_errors": null
}
```

## Content Projekte suchen & filtern

# Objekte

## Objekte eines Content Projektes auflisten

## Nach Objekten in einem Content Projekt suchen

## Objekte in einem Content Projekt filtern

## Ein neues Objekt in einem Content Projekt erstellen

## Datei hochladen

# Textgenerierung

## anstoßen

## generierte Texte herunterladen




# Kittens


### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Isis",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">If you're not using an administrator API key, note that
some kittens will return 403 Forbidden if they are hidden for admins only.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

