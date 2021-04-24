def initialize app
  @app = app
end

def call env
  case env['REQUEST_METHOD']
  when 'OPTIONS'
    response = Rack::Response.new

    response.add_header 'Access-Control-Allow-Origin', '*'
    response.add_header 'Access-Control-Allow-Methods', 'POST, OPTIONS'
    response.add_header 'Access-Control-Allow-Headers', 'Authorization, Content-Type'
    response.add_header 'Access-Control-Max-Age', '86400'

    response.to_a
  else
    status, headers, body = @app.call(env).to_a
    headers['Access-Control-Allow-Origin'] = '*'
    [status, headers, body]
  end
end
