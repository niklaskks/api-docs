# Introduction
The AX Semantics NLG Cloud ('NLG Cloud') is a product of AX Semantics.

## Basics
The NLG Cloud web application (`cockpit.ax-semantics.com`) is a self-service portal integrated in the NLG Cloud. It enables your access to functionality such as data transfer, text generation and integration of automated content generation into your website.

**All functionality of the platform is accessible via our API** at `api.ax-semantics.com` to ensure an easy integration into other platforms and systems.

## Terms and Definitions
* _Objects_ (aka document) are data nodes containing information from which a text can be generated 
* _Collcetions_ are collections of similar Objects combined with a text engine training and an engine configuration which includes the desired keyword density, text length, language etc.
* A _Training_ is an interpretative ruleset for the text engine, to derive information from data and transfer this information into natural language. Trainings are always dependent on a certain data structure.
* A _Content generation request_ is a request sent to the NLG Cloud to produce a text out of an Object based on the underlying training. The generated content is realized through an asynchronous process and is attached to the object after successful text generation.

We recently added new functionality for which we use new terms:
* _Projects_ bundle Trainings and Collections.
* _Collections_ help organize related or similar Documents. (These replaced "Content Projects")

  There is a vague resemblence to the old Content Projects; however they are very different on the inside.

* _Documents_ are managable data containers for which a text can be generated.  (These replaced "Things")



# Authentication
The API requires the input of an "Authorization header".

To retrieve the value of this token you have to log in using the web application; then you will find it in your profile. At the moment it is not possible to login using an API call. (We are working on it though.)


## Refresh-Token based API Authentification
The API uses time-limited tokens, which need to be generated first based on your refresh token.

Get your refresh_token from the GUI in the cockpit, and use this to request an `id_token`

```
curl --request POST \
  --url 'https://idm.ax-semantics.com/v1/token-exchange/' \
  --header 'Content-Type: application/json' \
  --data '{"refresh_token": "**INSERT REFRESH_TOKEN HERE**"}'
```

This returns your id_token:
```
{"token_type":"JWT","expires_in":86400, "id_token":"eyJ0eXAiOiJKV1ciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2F4LXNlbWFudGljcy5ldS5hdXRoMC5jb20vIiwiYXVkIjoiYnVmdzhQMUdTSGdPTzVnMVFWbjdVM2hxMkhvWkpTSFciLCJlbWFpbCI6mXXXAbWFkZmxleC5kZSIsImV4cCI6MTQ4NzM0NjgwNSwiaWF0IjoxNDg3Mjxxxx.zCFHRQkYAk3SQLzJTCrwRzuv9hMZcgqbef3gxxxxxx"}
```

This can then be used to call the API

`Authorization: JWT eXAiOiJKV1ciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2F4LXNlbWFudGljcy5ldS5hdXRoMC5jb20vIiwiYXVkIjoiYnVmdzhQMUdTSGdPTzVnMVFWbjdVM2hxMkhvWkpTSFciLCJlbWFpbCI6mXXXAbWFkZmxleC5kZSIsImV4cCI6MTQ4NzM0NjgwNSwiaWF0IjoxNDg3Mjxxxx.zCFHRQkYAk3SQLzJTCrwRzuv9hMZcgqbef3gxxxxxx`


For example to upload something into the bulk-api:

```shell
curl --request POST \
  --header 'Authorization: JWT *INSERT_ID_TOKEN_HERE*' \
  --header "Accept: application/json" \
  --url https://bulk-api.ax-semantics.com/v1/uploads/ \
  --form 'hint=json' \
  --form 'collection_id=**INSERT-COLLECTION-ID-HERE**' \
  --form 'data_file=@/home/user/datafile.json;filename=datafile.json'
  ```
  
  
  (This replaces the old syntax of `Authorization: Token aa5d2e36668c11e5964038bc572ec103`)


