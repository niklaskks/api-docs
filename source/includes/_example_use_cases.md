# Example use cases

## Generate content from existing data

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
