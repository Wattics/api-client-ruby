class Config
  PRODUCTION = 'https://web-collector.wattics.com/measurements/v2/unifiedjson/'.freeze
  DEVELOPMENT = 'https://dev-web-collector.wattics.com/measurements/v2/unifiedjson/'.freeze
  def initialize(environment, username, password)
    @environment = environment
    @uri = environment(environment)
    @username = username
    @password = password
  end

  def environment(environment)
    if environment == :PRODUCTION
      PRODUCTION
    elsif environment == :DEVELOPMENT
      DEVELOPMENT
    end
  end

  def getUsername
    @username
  end

  def getPassword
    @password
  end

  def getUri
    @uri
  end
end
