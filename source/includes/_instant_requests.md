# Instant Requests

Instant Requests enable you to generate Content without having to create data objects beforehand. You simply provide all necessary data with your request, we generate a text for this data set and deliver it via webhook. 

With Instant Requests we do not store your data sets, nor do we store the generated content (hence the mandatory webhook delivery).

## Prerequisites

To use Instant Requests you need:

* a Project
* a Training
* a web service to which we deliver generated content

## Using Instant Requests

Simply POST all necessary data to our dedicate api endpoint.

```shell
$ curl --request POST \
  --url 'https://api.ax-semantics.com/v2/instant/' \
  --header 'Authorization: JWT eXAiOiJKV1ciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2F4LXNlbWFudGljcy5ldS5hdXRoMC5jb20vIiwiYXVkIjoiYnVmdzhQMUdTSGdPTzVnMVFWbjdVM2hxMkhvWkpTSFciLCJlbWFpbCI6mXXXAbWFkZmxleC5kZSIsImV4cCI6MTQ4NzM0NjgwNSwiaWF0IjoxNDg3Mjxxxx.zCFHRQkYAk3SQLzJTCrwRzuv9hMZcgqbef3gxxxxxx' \
  --header 'Content-Type: application/json' \
  --data '{
        "webhook_url": "https://example.com/pim/new_text_for/3/",
        "webhook_secret": "secret secret",
        "data": {"name": "some name", "uid": 11112222, "weight": {"value": 19, "unit": "kg"}},
        "collection": 19,
        "uid": 11112222,
        }'
```

> The API returns status code 202 ACCEPTED and a JSON string, such as:
```json
{"We have started generating your text."}
```

Once the text has been generated, we will attempt to deliver it at the given webhook url.


### Endpoint
`POST /v2/instant/`
