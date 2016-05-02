# Introduction to the myAX API

## Basics
The myAX web application (`my.ax-semantics.com`) is a self-service portal integrated in the AX NLG Cloud. It enables your access to functionality such as data transfer, text generation and integration of automated content generation into your website.

**All functionality of the platform is accessible via our API** at `api.ax-semantics.com` to ensure an easy integration into other platforms and systems.

## Terms and Definitions
* _Objects_ (aka Things) are data nodes containing information from which a text can be generated
* _Content Projects_ are collections of similar Objects combined with a text engine training and an engine configuration which includes the desired keyword density, text length, language etc.
* A _Training_ is an interpretative ruleset for the AX Text-Engine, to derive information from data and transfer this information into natural language. Trainings are always dependent on a certain data structure.
* A _Content generation request_ is a request sent to the NLG Cloud to produce a text out of an Object based on the underlying training. The generated content is realized through an asynchronous process and is attached to the object after successful text generation.


# Authentication
The API requires the input of an "Authorization header". The value will be relayed to you after your login.

The header should look like this:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

You have to exchange `aa5d2e36668c11e5964038bc572ec103` for your own API token.

## Login
```python
import axsemantics

try:
    axsemantics.login(user='USER@EXAMPLE.COM', password='SECRET_PASSWORD')
    print(axsemantics.constants.API_TOKEN)

except axsemantics.AuthenticationError:
    pass
```

```shell
$ curl --request POST \
  --url https://api.ax-semantics.com/v1/rest-auth/login/ \
  --header 'Content-Type: application/json' \
  --data '{"email":"USER@EXAMPLE.COM","password":"SECRET_PASSWORD"}'
```

> The API returns a JSON string such as:

```json
{"key":"aa5d2e36668c11e5964038bc572ec103"}
```

You will receive your token as response to your login request.

### Endpoint
`POST /v1/rest-auth/login/`

