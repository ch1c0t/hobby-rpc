def initialize app, origins: nil
  @app = app
  @origins = origins
end

def call env
  origin = '*'

  if @origins
    if @origins.include? env['HTTP_ORIGIN']
      origin = env['HTTP_ORIGIN']
    else
      return [400, {}, '400']
    end
  end

  case env['REQUEST_METHOD']
  when 'OPTIONS'
    response = Rack::Response.new

    response.add_header 'Access-Control-Allow-Origin', origin
    response.add_header 'Access-Control-Allow-Methods', 'POST, OPTIONS'
    response.add_header 'Access-Control-Allow-Headers', 'Authorization, Content-Type'
    response.add_header 'Access-Control-Max-Age', '86400'

    response.to_a
  else
    status, headers, body = @app.call env
    headers['Access-Control-Allow-Origin'] = '*'
    [status, headers, body]
  end
end
