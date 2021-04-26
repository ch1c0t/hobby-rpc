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

[hobby-rpc]: https://rubygems.org/gems/hobby-rpc
[forbidden]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403
