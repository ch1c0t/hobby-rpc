def self.models
  @models ||= []
end

def self.find_by_token token
  models.each do |model|
    if user = (model.find_by_token token)
      return user
    end
  end
end

def can? _function
end

def self.included model
  models << model
end
