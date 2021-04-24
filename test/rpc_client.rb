require 'json'
require 'excon'

class RPCClient
  def initialize url:, token:
    headers = {
      'Content-Type'  => 'application/json',
      'Authorization' => token,
    }

    @excon = if url.start_with? 'http'
               Excon.new url, headers: headers
             else
               Excon.new 'unix:///', socket: url, headers: headers
             end
  end

  def call function, input
    body = {
      fn: function,
      in: input,
    }
    @excon.post body: body.to_json
  end
end
