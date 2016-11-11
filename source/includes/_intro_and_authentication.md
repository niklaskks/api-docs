# Introduction to the myAX API

## Basics
The myAX web application (`my.ax-semantics.com`) is a self-service portal integrated in the AX NLG Cloud. It enables your access to functionality such as data transfer, text generation and integration of automated content generation into your website.

**All functionality of the platform is accessible via our API** at `api.ax-semantics.com` to ensure an easy integration into other platforms and systems.

## Terms and Definitions
* _Objects_ (aka Things) are data nodes containing information from which a text can be generated
* _Content Projects_ are collections of similar Objects combined with a text engine training and an engine configuration which includes the desired keyword density, text length, language etc.
* A _Training_ is an interpretative ruleset for the AX Text-Engine, to derive information from data and transfer this information into natural language. Trainings are always dependent on a certain data structure.
* A _Content generation request_ is a request sent to the NLG Cloud to produce a text out of an Object based on the underlying training. The generated content is realized through an asynchronous process and is attached to the object after successful text generation.

We recently added new functionality for which we use new terms:
* _Projects_ bundle Trainings and Collections.
* _Collections_ help organize related or similar Documents.

  There is a vague resemblence to the old Content Projects; however they are very different on the inside.

* _Documents_ are managable data containers for which a text can be generated.

  These in turn seem to resemble Objects or Things, but provide a flexible and powerful storage solution.


# Authentication
The API requires the input of an "Authorization header".

To retrieve the value of this token you have to log in using the web application; then you will find it in your profile. At the moment it is not possible to login using an API call. (We are working on it though.)

The header should look like this:

`Authorization: Token aa5d2e36668c11e5964038bc572ec103`

You have to exchange `aa5d2e36668c11e5964038bc572ec103` for your own API token.

