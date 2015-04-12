require! \sendgrid

mail = sendgrid olio.config.mail.user, olio.config.mail.pass
promisify-all mail

export send = (to, subject, text) ->*
  yield mail.send-async do
    to:       to
    from:     olio.config.mail.from
    fromname: olio.config.mail.fromname
    subject:  subject
    text:     text
