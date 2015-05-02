# Rapsheet
### Installation
1. Install [ArangoDB](https://www.arangodb.com/)
1. Clone the repository
1. Copy `host.ls.example` -> `host.ls` and edit it.  Configuration in `host.ls` overrides those in `olio.ls`.
1. `npm install`
1. Make sure `./node_modules/.bin` is in your path
1. `olio api`
1. To view api documentation, browse to `http://localhost:9002`

### Usage
Rapsheet is begining life as an api, so you can try it out with curl.  Right now it only provides a simple authentication mechanism against email addresses.  Here are some sample commands:

If you have sendgrid enabled, this will mail you a token which you must use on all subsequent requests:

`curl "localhost:9002/claim?email=myemail@example.com"`

This will get you a list of token hints, provided you know at least one of them:

`curl "localhost:9002/tokens?token=cd428d7df51b0c5f3f0835dc0427c3fd"`

And this will delete a token with the given hint:

`curl "localhost:9002/tokens?token=cd428d7df51b0c5f3f0835dc0427c3fd&hint=347h"`

### Project Structure
Standard [olio](https://github.com/naturalethic/olio) setup:

```
/api  # Api endpoints
/lib  # Support libraries
olio.ls # Application configuration
host.ls # Host specific configuration
```
