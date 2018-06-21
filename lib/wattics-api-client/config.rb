class Config
  attr_reader :environment, :uri, :username, :password
  PRODUCTION = 'https://web-collector.wattics.com/measurements/v2/unifiedjson/'.freeze
  DEVELOPMENT = 'https://dev-web-collector.wattics.com/measurements/v2/unifiedjson/'.freeze
  TEST = 'http://localhost:8080/measurements/v2/unifiedjson/'.freeze
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
    elsif environment == :TEST
      TEST
    end
  end

end
