require_relative 'helper'

it 'works' do
  client = RPCClient.new url: socket, token: 'a valid token'

  response = client.call 'First', 1
  assert_response response, 1, 200

  input = { some: :input }
  response = client.call 'Second', input
  assert_response response, input, 200
end
