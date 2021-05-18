def self.roles
  @roles ||= []
end

# Accepts a `token`(String).
#
# This method is for finding a user.
# It is expected by Hobby::Auth:
# https://github.com/ch1c0t/hobby-auth
#
# If you store all active sessions in one place,
# you might want to redefine it,
# since the default implementation below is O(n).
#
# Still, it seems to be a reasonable default,
# because it's ready, by default, for cases when
# there might be multiple kinds of tokens and multiple ways to store them.
# And, thanks to Ruby, it's easy to redefine it when it's not needed.
#
# Returns a user or nil(if a session for such token does not exist).
def self.find_by_token token
  roles.each do |role|
    if user = (role.find_by_token token)
      return user
    end
  end
  return nil
end

def can? _function
end

def self.included role
  roles << role
end
