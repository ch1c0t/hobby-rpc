require 'hobby'
require 'hobby/auth'
require 'hobby/json/keys'

include Hobby
include Auth[User]
include JSON::Keys

key :fn, String
optional {
  key :in
}

User post {
  begin
    function = keys[:fn]

    if user.can? function
      function = Object.const_get function
      function.(user: user, input: keys[:in])
    else
      response.status = 403
    end
  rescue
    response.status = 400
  end
}

def initialize hash = {}
  if cors_origins = hash[:cors_origins]
    use CORS, origins: cors_origins
  else
    use CORS
  end
end
