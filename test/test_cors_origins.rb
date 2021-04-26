require_relative 'helper'

app = Hobby::RPC.new cors_origins: ['https://some.domain']

it 'accepts a preflight request with a valid origin', app: app do
  client = RPCClient.new url: socket, token: 'a valid token', origin: 'https://some.domain'

  response = client.options
  is response.status, 200

  h = response.headers
  is h['Access-Control-Allow-Methods'], 'POST, OPTIONS'
  is h['Access-Control-Allow-Headers'], 'Authorization, Content-Type'
  is h['Access-Control-Max-Age'], '86400'
  is h['Access-Control-Allow-Origin'], 'https://some.domain'
end

it 'rejects a request with an invalid origin', app: app do
  client = RPCClient.new url: socket, token: 'a valid token', origin: 'https://not.allowed.origin'

  response = client.options
  is response.status, 400
end
