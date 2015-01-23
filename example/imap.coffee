require("#{__dirname}/../src/core") (err, Person, Message, Plugin) ->
  return console.log 'err', err if err

  con = Plugin('imap').connect({    
    user: process.env.USER
    password: process.env.PASS
    host: 'imap.gmail.com'
    port: 993
    tls: true
  })
  con.catch (err) ->
    console.log 'err', err

  con.then (inbox) ->
    # get unread mails
    inbox.unread().then (messages) ->
      console.log 'done unread', messages.length

    # get latest(newest) mail
    inbox.get(inbox.messages.total - 1, '*').then (messages) ->
      console.log 'done get newest', messages.length

    # get first(oldest) mail
    inbox.get(0, 1).then (messages) ->
      console.log 'done get oldest', messages.length