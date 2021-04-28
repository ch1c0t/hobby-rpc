Gem::Specification.new do |g|
  g.name          = 'hobby-rpc'
  g.files         = ['lib/hobby/rpc.rb']
  g.version       = '0.0.2'
  g.summary       = 'A simple RPC system.'
  g.description   = 'A simple RPC system for callable Ruby constants. It allows to expose them over HTTP safely, only to authorized users.'
  g.author        = 'Anatoly Chernov'
  g.email         = 'chertoly@gmail.com'
  g.license       = 'ISC'
  g.homepage      = 'https://github.com/ch1c0t/hobby-rpc'

  g.add_dependency 'hobby', '~> 0.2.2'
  g.add_dependency 'hobby-auth', '~> 0.1.0'
  g.add_dependency 'hobby-json-keys', '~> 0.0.0'
  g.add_dependency 'hobby-cors', '~> 0.1.0'
end
