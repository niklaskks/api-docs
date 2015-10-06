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
obj = api.content_project.get(1).create(uid=1, name='demo', pure_data=data)
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
`POST /v1/content-project/{CP_ID}/thing/`

Sie müssen `{CP_ID}` durch die ID Content Projekts ersetzen.

## ein bestehendes Objekt aktualisieren
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

Sie müssen `{CP_ID}` ersetzen durch die ID des Content Projekts; und `{OBJ_ID}`
durch die ID des betreffenden Objektes, dies ist *nicht Ihre selbst gewählte UID*.

## ein bestehendes Objekt löschen
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

Sie müssen `{CP_ID}` ersetzen durch die ID des Content Projekts; und `{OBJ_ID}`
durch die ID des betreffenden Objektes, dies ist *nicht Ihre selbst gewählte UID*.

# Content Generierung
Wenn die Daten der Objekte den projektabhängigen Qualitätskriterien genügen,
kann über die API die Contentgenerierung gestartet werden.

## Content für ein einzelnes Objekt generieren lassen
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

> Als Antwort bekommt man Angaben zu dem sog. Text Request:

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

Sie müssen `{CP_ID}` ersetzen durch die ID des Content Projekts; und `{OBJ_ID}`
durch die ID des betreffenden Objektes, dies ist *nicht Ihre selbst gewählte UID*.

`{force}` ist ein sog. Queryparameter, mit dem Sie angeben können ob eventuell
bereits bestehender Content durch neu Generierten ersetzt werden soll. Die
Angabe ist optional: wenn Sie sie weglassen, wird **force=false** angenommen.

- **?force=false** (default): gibt es für dieses Objekt noch keinen Content, so
wird dieser generiert. Gibt es bereits Content, geschieht nichts weiter.
- **?force=true**: eventuell bestehender Content wird ersetzt

## Content für ein gesamtes Content Projekt generieren lassen
```python
import axsemantics
api = axsemantics.login('', '')

success, count = api.content_project.get(1).generate_content(force=True)
if success:
    print('Started content generation for {} objects'.format(count))
```

```shell
curl --request POST \
  --url "https://api.ax-semantics.com/v1/content-project/2123/generate_content/?force=true" \
  --header "Authorization: Token aa5d2e36668c11e5964038bc572ec103"
```

> Die API gibt beispielsweise folgendes JSON zurück:

```json
{"status":"CALLED","number":3}
```
### Endpoint
`POST /v1/content_project/{CP_ID}/generate_content/{force}`

Sie müssen `{CP_ID}` durch die ID des betreffenden Content Projekts ersetzen.

`{force}` ist ein sog. Queryparameter, mit dem Sie angeben können ob eventuell
bereits bestehender Content durch neu Generierten ersetzt werden soll. Die
Angabe ist optional: wenn Sie sie weglassen, wird **force=false** angenommen.

## Status der Contentgenerierung abfragen
```python
import axsemantics
api = axsemantics.login('', '')

obj = api.content_project.get(1).get(123)
if obj.status:
    print('Content for this object has already been requested.')
```

```shell
$ curl --request GET \
    --header "Authorization: Token " \
    --url "https://api.ax-semantics.com/v1/content-project/1/thing/123/"
```

> Das relevante Feld in der API-Antwort heißt **status**.

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

Sie müssen `{CP_ID}` ersetzen durch die ID des Content Projekts; und `{OBJ_ID}`
durch die ID des betreffenden Objektes, dies ist *nicht Ihre selbst gewählte UID*.

## Generierten Content abrufen für einzelnes Objekt
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

> Die API gibt beispielsweise folgende Information zum Content Request aus:

```json
{ "id": 456,
  "content_project": 1,
  "state": "Success",
  "generated_text_in_html": "<h1>Überschrift</h1>\n<p>Absatz</p>",
  "generated_text": "# Überschrift\nAbsatz",
  "error_msg": null,
  "...": "..." }
```

Der generierte Content wird im Originalformat und in HTML-Formatierung
ausgegeben. Das Originalformat ist üblicherweise [Markdown](https://daringfireball.net/projects/markdown/syntax/).

### Endpoint
`GET /v1/content-project/{CP_ID}/thing/{OBJ_ID}/content_request/`

Ersetzen Sie `{CP_ID}` durch die ID des betreffenden Content Projects; und
`{OBJ_ID}` durch die ID des Objektes, dies ist *nicht die von Ihnen angegebende
UID*.

## Generierten Content abrufen für gesamtes Content Projekt
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
Mittels Autoprocessing können Sie Content generieren und zum download
bereitstellen lassen. Sie erhalten eine E-Mail, wenn der Content für Sie
bereit liegt.

Sie können Autoprocessing veranlassen, wenn sie ein entsprechendes Flag beim
Bulkupload angeben. Ihre Daten werden zunächst in das angegebene Content
Projekt übernommen, dann wird hierfür Content generiert, der anschließend zum
Download bereitgestellt wird, und schließlich wird Ihnen eine
Benachrichtigungs-E-Mail geschickt.
### Endpoint
`POST /v1/bulkupload/`

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

Sie müssen `{CP_ID}` durch die id des jeweiligen Content Projektes ersetzen.

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
`DELETE /v1/content-project/{CP_ID}/`

Sie müssen `{CP_ID}` durch die id des zu löschenden Content Projektes ersetzen.

<aside class="warning">
Wenn Sie ein Content Projekt löschen, werden ALLE Objekte und deren generierte
Texte ebenfalls gelöscht! Die API wird nicht nachfragen sondern ohne extra
Bestätigung den Löschauftrag ausführen.
</aside>

# Projektübergreifende Aktionen

Einige Aktionen lassen sich für Objekte unabhängig von ihrer Zugehörigkeit eines Content Projektes durchführen.
