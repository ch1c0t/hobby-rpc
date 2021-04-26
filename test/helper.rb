require 'minitest'
Minitest.autorun

require 'terminal-table'
require 'ap'
AwesomePrint.defaults = {
  indent: -2,
}

module Minitest::Assertions
  def is subject, predicate
    assert_equal predicate, subject
  end

  def assert_response response, expected_output, expected_status
    expected_body = expected_output.to_json
    if (response.status != expected_status) || (response.body != expected_body)
      actual_output = begin
                        JSON.parse response.body
                      rescue => error
                        error
                      end

      table = Terminal::Table.new headings: ['', 'Expected', 'Actual'],
        rows: [
          ['response.status', expected_status, response.status],
          ['response JSON', expected_output.awesome_inspect, actual_output.awesome_inspect],
        ]
      fail "\n#{table}"
    end
  end
end

DIR = '/tmp/hobby-rpc.tests'
Dir.mkdir DIR unless Dir.exist? DIR

require 'puma'
require 'hobby/rpc'
require 'securerandom'

require_relative 'rpc_client'

module AppSetup
  def setup
    @pid = fork do
      require_relative 'service'

      server = Puma::Server.new app
      server.add_unix_listener socket
      server.run
      sleep
    end

    sleep 0.1 until File.exist? socket
  end

  def teardown
    Process.kill 9, @pid
    File.delete socket if File.exist? socket
  end
end

def test name, description, app: Hobby::RPC.new, &block
  socket = "#{DIR}/#{name}.#{Time.now.to_i}.#{SecureRandom.uuid}"

  Class.new Minitest::Test do
    include AppSetup

    define_method :app do app end
    define_method :socket do socket end
    define_method description, &block
  end
end

def it summary, app: Hobby::RPC.new, &block
  name = File.basename caller_locations.first.path, '.rb'
  test name, "#{name}(it #{summary})", app: app, &block
end
