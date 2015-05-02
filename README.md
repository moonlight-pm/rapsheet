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

`curl "localhost:9002/token?email=myemail@example.com"`

This will get you a list of token hintsf:

`curl "localhost:9002/token/hints?token=nyuf1en6mz08wdbbdhxzey77bbt423mfjyzxucy723vz51gz3d1g"`

And this will destroy a token with the given hint:

`curl "localhost:9002/token/destroy?token=nyuf1en6mz08wdbbdhxzey77bbt423mfjyzxucy723vz51gz3d1g&hint=005ekgdqfja0kwrj0b7974bdmx"`

### Project Structure
Standard [olio](https://github.com/naturalethic/olio) setup:

```
/api        # Api endpoints
/lib        # Support libraries
olio.ls     # Application configuration
host.ls     # Host specific configuration
validate.ls # Custom validations
```
