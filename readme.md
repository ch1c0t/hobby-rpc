## Introduction

Hobby-RPC is a simple RPC system for callable Ruby constants. It allows to expose them over HTTP safely, only to authorized users.

It is available on RubyGems as [hobby-rpc][hobby-rpc].

## Usage
### Defining user roles

First, we need to define who the users are and what they can do. Otherwise, all the requests will return [403 Forbidden][forbidden].

We can do this by creating at least one user role. A user role is a class that includes `Hobby::RPC::User` and implements `.find_by_token` and `#can?` methods. For example:

```ruby
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
    'return any value'
  end
end

module SomeNamespace
  module SomeFunction
    def self.call user:, input:
      'return any value'
    end
  end
end
```

A `user` would be an instance of a user role defined earlier.

### Running a server
To start a server, we can use [rackup][rackup]. For that, we can put the
following into `config.ru`:
```ruby
require 'hobby/rpc'
run Hobby::RPC.new
```

Or we can use Puma directly as follows:
```ruby
require 'hobby/rpc'
require 'puma'

server = Puma::Server.new Hobby::RPC.new
server.add_tcp_listener '127.0.0.1', port
server.run
sleep
```

## Development

To work on `hobby-rpc` itself, you can build the project and run the tests:

`bundle exec rake`

[hobby-rpc]: https://rubygems.org/gems/hobby-rpc
[forbidden]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403
[rackup]: https://github.com/rack/rack/wiki/(tutorial)-rackup-howto
