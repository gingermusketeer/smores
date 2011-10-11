# S'mores

## DESCRIPTION

S'mores is a [Campfire](http://campfirenow.com) library written in CoffeeScript for Node.

## INSTALLATION

1. Clone the repository
2. Change into the directory
3. Install the dependencies with `npm install`

## USAGE

The simplest example of using Smores as a bot that listens for the text `PING`.

```coffeescript
Campfire = require('smores').Campfire

campfire = new Campfire ssl: true, token: 'api_token', account: 'subdomain'

campfire.join 12345, (error, room) ->
  room.listen (message) ->
    if message.body is 'PING'
      console.log 'PING received, sending PONG'
      room.speak 'PONG', (error, response) ->
        console.log 'PONG sent'
```

More detailed documented of the classes and methods is coming soon.

### Campfire

Coming soon...

### Message

Coming soon...

### Room

Coming soon...

## CONTRIBUTE

Here's the most direct way to get your work merged into the project:

1. Fork the project
2. Clone down your fork
3. Create a feature branch
4. Hack away and add tests. Not necessarily in that order
5. Make sure everything still passes by running tests
6. If necessary, rebase your commits into logical chunks, without errors
7. Push the branch up
8. Send a pull request for your branch

## LICENSE

The MIT License

Copyright (c) 2011 Tom Bell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
