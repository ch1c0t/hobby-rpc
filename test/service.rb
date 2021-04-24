class Client
  include Hobby::RPC::User

  def self.find_by_token token
    new if 'a valid token'
  end

  def can? function
    [ 'First', 'Second' ].include? function
  end
end

module First
  def self.[] user:, input:
    p "user: #{user}"
    p "input: #{input}"
    input
  end
end

module Second
  def self.[] hash
    p "from Second: #{hash}"
    hash[:input]
  end
end
