require_relative 'helper'

it 'rejects invalid tokens' do
  client = RPCClient.new url: socket, token: 'invalid token'

  input = { some: :input }
  response = client.call 'Second', input
  assert_response response, 403, 403
end

it 'rejects not allowed functions' do
  client = RPCClient.new url: socket, token: 'a valid token'

  input = { some: :input }
  response = client.call 'NotAllowedConstant', input
  assert_response response, 403, 403
end
