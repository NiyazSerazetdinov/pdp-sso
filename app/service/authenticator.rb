class Authenticator
  attr_reader :auth_data

  def initialize(auth_data)
    @auth_data = auth_data
  end
end
