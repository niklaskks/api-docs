---
title: AX Semantics API Referenz

language_tabs:
  - shell
  - python

toc_footers:
  - <a href='https://my.ax-semantics.com/#/account/sign-up'>Kostenlos registrieren</a>
  - <a href="https://github.com/axsemantics/api-docs/">Quellcode auf Github</a>
  - <a href='http://github.com/tripit/slate'>Erstellt mit Slate</a>

search: true
---


# Authentication

Die API verlangt die Angabe eines sog. "Authorization headers". Der Wert wird
Ihnen nach Login übermittelt.

Der Header sollte wie folgt aussehen:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

Sie müssen `aa5d2e36668c11e5964038bc572ec103` durch Ihr persönliches Token ersetzen.

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

> Die API gibt dabei beispielsweise folgendes JSON zurück:

```json
{"key":"aa5d2e36668c11e5964038bc572ec103"} 
```

Nach dem Login erhalten Sie Ihr Token in der Antwort der API.

### Endpoint
`POST /v1/rest-auth/login/`

# Objekte

Ihre Datensätze werden unabhängig vom Format als Objekte gespeichert. Alle
Objekte sind immer einem Content Projekt zugeordnet.

## Neue Objekte anlegen

```python
import axsemantics
api = axsemantics.login('', '')

data = {'key':'value'}
obj = api.content_project.get(1)\
      .create(uid=1, name='demo', pure_data=data)
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/content-project/1/thing/ \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --data '{"uid":1, "name":"demo", "content_project":1, "pure_data":"{\"key\":\"value\"}"}'
```

Um ein neues Objekt anzulegen, POSTen Sie dessen Daten in ein bestehendes
Content Projekt. Geben Sie ebenfalls die ID des Content Projekts an.

Pflichtangaben bei allen Objekten sind:

 - **uid**: String mit beliebigem Inhalt; hiermit können Sie Ihren Datensatz
 identifizieren
 - **name**: String mit beliebigem Inhalt; der sprechende Bezeichner dieses
 Datensatzes
 - **content_project**: Integer; gibt das Content Projekt an, dem dieser
 Datensatz zugeordnet werden soll
 - **pure_data** (nur bei entsprechenden Projekten): JSON
 
Je nach Inhaltstyp kann es weitere Pflichtfelder geben.

### Hinweise zu pure_data

Falls Sie cURL verwenden, müssen Sie den JSON-String für das pure_data-Feld
noch schützen. Im shell-Beispiel sehen Sie, dass die Anführungszeichen durch ein
vorangestelltes Backslash geschützt wurden. 

### Endpoint
`POST /v1/content-project/{ID}/thing/`

Sie müssen `{ID}` durch die ID Content Projekts ersetzen.

## ein bestehendes Objekt aktualisieren

## ein bestehendes Objekt löschen

# Content Projekte

"Content Projekte" stellen jeweils die Trainings dar. Innerhalb der Content
Projekte sind die einzelnen Datensätze als Objekte abgelegt; die Objekte haben
jeweils den gleichen Datentyp.

## Content Projekte auflisten

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

### Endpoint
`GET /v1/content-project/`

## Ein bestimmtes Content Projekt anzeigen

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

### Endpoint
`GET /v1/content-project/{ID}/`

Sie müssen `{ID}` durch die id des jeweiligen Content Projektes ersetzen.

## Neues Content Projekt anlegen

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

### Endpoint
`POST /v1/content-project/`

Sie müssen folgende Felder angeben: 

 - **name**: der von Ihnen gewählte Name dieses Content Projekts, geben Sie
 hier einen String an
 - **engine_configuration**: Die ID der passenden Engine Configuration, dies
 muss ein Integer sein. Die IDs der Ihnen zur Verfügung stehenden Engine
 Configurations erfahren Sie von dem Endpoint für "Engine Configuration".
 
Sie können folgende Felder angeben:

 - **keyword_deviation**: Dezimalzahl, z.B.: '33.0'
 - **keyword_density**: Dezimalzahl, z.B.: '3.0'

## Content Projekte suchen & filtern

## Content Projekte löschen

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

> Die API antwortet mit einem '204 NO CONTENT'-Status.

### Endpoint
`DELETE /v1/content-project/{ID}/`

Sie müssen `{ID}` durch die id des zu löschenden Content Projektes ersetzen.

<aside class="warning">
Wenn Sie ein Content Projekt löschen, werden ALLE Objekte und deren generierte
Texte ebenfalls gelöscht! Die API wird nicht nachfragen sondern ohne extra
Bestätigung den Löschauftrag ausführen.
</aside>

# Objekte

## Objekte eines Content Projektes auflisten

## Nach Objekten in einem Content Projekt suchen

## Objekte in einem Content Projekt filtern

## Ein neues Objekt in einem Content Projekt erstellen

## Datei hochladen

# Textgenerierung

## anstoßen

## generierte Texte herunterladen
