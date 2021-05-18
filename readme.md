## Introduction

Hobby-RPC is a simple RPC system for callable Ruby constants. It allows to expose them over HTTP safely, only to authorized users.

It is available on RubyGems as [hobby-rpc][hobby-rpc].

The idea is to separate transport and business logic. Hobby-RPC handles the transport layer and
provides [a client for browsers][hobby-rpc.clients.js]; we can focus on defining business logic,
which will be transport-independent.

## Usage
### Defining user roles

First, we need to define who the users are and what they can do. Otherwise, all the requests will return [403 Forbidden][forbidden].

We can do this by creating at least one user role. A user role is a class that includes `Hobby::RPC::User` and implements `.find_by_token` and `#can?` methods. For example:

```ruby
require 'hobby/rpc'

class Client
  include Hobby::RPC::User

  # Accepts a `token`(String).
  #
  # Here we can look up at the place where we store active sessions.
  # It could be a Redis server mapping session tokens to users.
  #
  # Returns a user or nil(if a session for such token does not exist).
  def self.find_by_token token
    new if 'the token' == token
  end

  # Accepts a `function`(String).
  #
  # This determines what a user can do. A user will be allowed to call
  # `function` only when this method returns truthy value.
  #
  # One way to implement it is with Redis Sets:
  # https://redis.io/commands/sismember
  def can? function
    ['SomeFunction', 'SomeNamespace::SomeFunction'].include? function
  end
```

`Client` is the only role at the moment, but we can define as many as
we would like. The role names would be specific to the business logic
of your application.

### Defining functions
An RPC function is a Ruby constant whose object implements `.call` method
that can accept `user` and `input` parameters. It can accept them either
as a Hash or as keyword arguments. For example:

```ruby
module SomeFunction
  def self.call hash
    hash[:user]
    hash[:input]
    'return any value serializable to JSON'
  end
end

module SomeNamespace
  module SomeFunction
    def self.call user:, input:
      'return any value serializable to JSON'
    end
  end
end
```

A `user` would be an instance of a user role defined earlier.

An `input` would be an object deserialized from JSON or `nil`.
It is what the client can pass to a function as an argument.

The functions must return something serializable `#to_json`.
The client will get this as a response. Or, in case of an error inside of a function,
the client will get [400 Bad Request][bad_request].

### Running a server
To start a server, we can use [rackup][rackup]. For that, we can put the
following into `config.ru`:
```ruby
run Hobby::RPC.new
```

By default, it will return permissive [CORS][cors] headers(`Access-Control-Allow-Origin: *`)
for requests from any origin. For private APIs, you might want to restrict that:
```ruby
Hobby::RPC.new cors_origins: ['https://some.domain', 'https://another.domain']
```

### Calling functions

To call RPC functions from browsers, you can use [this client][hobby-rpc.clients.js].

## Development

To work on `hobby-rpc` itself, you can build the project and run the tests:

`bundle exec rake`

[hobby-rpc]: https://rubygems.org/gems/hobby-rpc
[forbidden]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403
[bad_request]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400
[rackup]: https://github.com/rack/rack/wiki/(tutorial)-rackup-howto
[cors]: https://en.wikipedia.org/wiki/Cross-origin_resource_sharing
[hobby-rpc.clients.js]: https://github.com/ch1c0t/hobby-rpc.clients.js
