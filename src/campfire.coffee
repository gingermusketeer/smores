Room    = require './room'
Message = require './message'

# Public: Handles the connection to the Campfire API.
class Campfire
  # Public: Configures the connection to the Campfire API.
  #
  # options - Hash of options.
  #           token   - A String of your Campfire API token.
  #           account - A String of your Campfire account.
  #           ssl     - A Boolean of whether to use SSL or not.
  #
  # Returns nothing.
  # Raises Error if no token is supplied.
  # Raises Error if no account is supplied.
  constructor: (options = {}) ->
    throw new Error 'Please provide an API token' unless options.token
    throw new Error 'Please provide an account name' unless options.account

    ssl = !!options.ssl

    @http   = if ssl then require 'https' else require 'http'
    @port   = if ssl then 443 else 80
    @domain = "#{options.account}.campfirenow.com"

    encoded = new Buffer("#{options.token}:x").toString('base64')
    @authorization = "Basic #{encoded}"

  # Public: Join a Campfire room by ID. The room instance is passed to the
  # callback function.
  #
  # id       - An Integer room ID for the Campfire room.
  # callback - An optional Function accepting an error message and room
  #            instance.
  #
  # Returns nothing.
  join: (id, callback) ->
    @room id, (err, room) ->
      return callback? err if err
      room.join (err) ->
        callback? err, room

  # Public: Get a JSON representation of the authenticated user making the
  # request. The JSON is passed to the callback function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  me: (callback) ->
    @get '/users/me', callback

  # Public: Get the rooms the authenticated user is in. The array of rooms is
  # passed to the callback function.
  #
  # callback - A Function accepting an error message and array of room
  #            instances.
  #
  # Returns nothing.
  presence: (callback) ->
    @get '/presence', (err, resp) =>
      return callback? err if err?
      callback null, (new Room @, room for room in resp.rooms)

  # Public: Get the rooms the authenticated user is able to join. The array of
  # rooms is passed to the callback function.
  #
  # callback - A Function accepting an error message and array of room
  #            instances.
  #
  # Returns nothing.
  rooms: (callback) ->
    @get '/rooms', (err, resp) =>
      return callback err if err
      callback null, (new Room @, room for room in resp.rooms)

  # Public: Get a room instance for the specified room ID. The room instance
  # is passed to the callback function.
  #
  # id       - An Integer room ID for the Campfire room.
  # callback - A Function accepting an error message and room instance.
  #
  # Returns nothing.
  room: (id, callback) ->
    @get "/room/#{id}", (err, resp) =>
      return callback err if err
      callback null, new Room(@, resp.room)

  # Public: Get all messages which contain the specified search term. The array
  # of rooms is passed to the callback function.
  #
  # term     - A String of the search term.
  # callback - A Function accepting an error message and array of message
  #            instances.
  #
  # Returns nothing.
  search: (term, callback) ->
    @get "/search/#{term}", (err, resp) =>
      return callback err if err
      callback null, (new Message @, msg for msg in resp.messages)

  # Public: Get a user instance for the specified user ID. The user instance
  # is passed to the callback function.
  #
  # id       - An Integer of the user ID.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  user: (id, callback) ->
    @get "/users/#{id}", callback

  # Public: Performs a HTTP DELETE request. The response JSON is passed to the
  # callback function.
  #
  # path     - A String of the path to request.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  delete: (path, callback) ->
    @request 'DELETE', path, '', callback

  # Public: Performs a HTTP GET request. The response JSON is passed to the
  # callback function.
  #
  # path     - A String of the path to request.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  get: (path, callback) ->
    @request 'GET', path, null, callback

  # Public: Performs a HTTP POST request. The response JSON is passed to the
  # callback function.
  #
  # path     - A String of the path to request.
  # body     - An Object or String for the request body.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  post: (path, body, callback) ->
    @request 'POST', path, body, callback

  # Performs an HTTP or HTTPS request. The response JSON is passed to the
  # callback function.
  #
  # method   - A String of the HTTP method.
  # path     - A String of the path to request.
  # body     - An Object or String for the request body.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  request: (method, path, body, callback) ->
    headers =
      'authorization': @authorization
      'host': @domain
      'content-type': 'application/json'

    if method is 'POST' or method is 'DELETE'
      body = JSON.stringify(body) if typeof body isnt 'string'
      headers['Content-Length'] = body.length

    opts =
      host: @domain
      port: @port
      method: method
      path: path
      headers: headers

    request = @http.request opts, (resp) ->
      data = ''

      resp.on 'data', (chunk) ->
        data += chunk

      resp.on 'end', ->
        try
          data = JSON.parse data
          callback null, data
        catch err
          callback err

    request.write(body) if method is 'POST'
    request.end()

exports.Campfire = Campfire
