## Automatic Story Exports

We create exports of your ContentProjects' generated texts at intervals. These are only created when necessary, for example if content has been changed since the last export was generated.

You can only retrieve information and data but cannot trigger a story export. Read: you can only use GET.

### List all automatic exports

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/'
```

#### Endpoint
`GET /v1/bulkdownloads/`

### List automatic export for a specific ContentProject

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/by-content-project/23/'
```

#### Endpoint
`GET /v1/bulkdownloads/by-content-project/{CP_ID}/`

Replace `{CP_ID}` with the ID of one of your ContentProjects.

### List automatic exports for specific Training ID

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/by-training-id/4433/'
```

#### Endpoint
`GET /v1/bulkdownloads/by-training-id/{TRAINING_ID}/`

Replace `{TRAINING_ID}` with the training ID which you can retrieve from our Training Wizard.

### List automatic exports matching search terms

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/search/your%20terms%20here'
```

#### Endpoint
`GET /v1/bulkdownloads/search/{search terms}`

You can use spaces in your search terms, but they **must** be encoded as `%20`; do not use `+`.

### Show details of a specific automatic export

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/25e05d20-106b-11e6-b78f-a71d52357c51/'
```

#### Endpoint
`GET /v1/bulkdownloads/{BD_UUID}/`

Replace `{BD_UUID}` with the UUID of the Automatic Story Export container (we call it Bulkdownload).

### Download one file of a specific automatic export

```shell
$ curl --request GET \
  --header 'Authorization: Token aa5d2e36668c11e5964038bc572ec103' \
  --url 'https://api.ax-semantics.com/v1/bulkdownloads/25e05d20-106b-11e6-b78f-a71d52357c51/4cdf787a-106b-11e6-a4c1-a71d52357c51/'
```

> The API will respond by sending you the file to download. Headers will contain information about filename and content type.

#### Endpoint
`GET /v1/bulkdownloads/{BD_UUID}/{BF_UUID}/`

Replace `{BD_UUID}` with the UUID for the Automatic Story export container, and replace `{BD_UUID}` with the UUID of the corresponding export file.

