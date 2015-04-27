# Rapsheet
### Installation
1. Clone the repository
2. Copy `host.ls.example` -> `host.ls`
3. `npm install`
4. Make sure `./node_modules/.bin` is in your path
5. `olio api`
6. To view api documentation, browse to `http://localhost:9002`

### Usage
Rapsheet is begining life as an api, so you can try it out with curl.  Right now it only provides a simple authentication mechanism against email addresses.  Here are some sample commands:

If you have sendgrid enabled, this will mail you a token which you must use on all subsequent requests:

`curl "localhost:9002/claim?email=myemail@example.com"`

This will get you a list of token hints, provided you know at least one of them:

`curl "localhost:9002/tokens?token=xxxxxxx"`

And this will delete a token with the given hint:

`curl "localhost:9002/tokens?token=xxxxxxx&hint=xxxx"`

### Project Structure
Standard `olio` setup:

```
/api  # Api endpoints
/lib  # Support libraries
/mid  # Middleware
/task # Olio tasks
host.ls # Host specific configuration
olio.ls # Application configuration
```

