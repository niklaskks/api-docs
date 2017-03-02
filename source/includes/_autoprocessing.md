## Autoprocessing

### Autoprocessing for bulkuploads

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

### Autoprocessing for new Objects
On request, your Content Project can be configured for "automatic processing". For any new objects, a text generation request is then triggered automatically once, saving you the call to request the content.


#### Endpoint
`POST /v1/bulkupload/`

