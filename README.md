# Rapsheet
### Installation
1. Install [ArangoDB](https://www.arangodb.com/)
1. Clone the repository
1. Copy `host.ls.example` -> `host.ls` and edit it.  Configuration in `host.ls` overrides those in `olio.ls`.
1. `npm install`
1. Make sure `./node_modules/.bin` is in your path
1. `olio web` to build the static web files
1. `olio api` to run the api/web server
1. To view api documentation, browse to `http://localhost:9002/api`, for the static site, browse the root.

### Usage
If you have sendgrid enabled, this will mail you a token which you must use on all subsequent requests:

`/token?email=myemail@example.com`

This will get you a list of token hints:

`/token/hints?token=nyuf1en6mz08wdbbdhxzey77bbt423mfjyzxucy723vz51gz3d1g`

And this will destroy a token with the given hint:

`/token/destroy?token=nyuf1en6mz08wdbbdhxzey77bbt423mfjyzxucy723vz51gz3d1g&hint=005ekgdqfja0kwrj0b7974bdmx`

### Project Structure
Standard [olio](https://github.com/naturalethic/olio) setup:

```
/api        # Api endpoints
/lib        # Support libraries
/web        # Browser client files
olio.ls     # Application configuration
host.ls     # Host specific configuration
validate.ls # Custom validations
```
