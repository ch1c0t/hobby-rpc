class Client
  include Hobby::RPC::User

  def self.find_by_token token
    new if 'a valid token' == token
  end

  def can? function
    [ 'First', 'Second' ].include? function
  end
end

module First
  def self.call user:, input:
    input
  end
end

module Second
  def self.call hash
    hash[:input]
  end
end
