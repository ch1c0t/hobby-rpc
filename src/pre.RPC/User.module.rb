def self.roles
  @roles ||= []
end

def self.find_by_token token
  roles.each do |role|
    if user = (role.find_by_token token)
      return user
    end
  end
  return false
end

def can? _function
end

def self.included role
  roles << role
end
