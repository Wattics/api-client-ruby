require 'rest-client'

class Client
  def send(measurement, config)
    begin
      response = RestClient::Request.execute(method: :post, url: config.getUri,
                          user: config.getUsername, password: config.getPassword,
                          payload: measurement.json, timeout: 2
                          )
      return response
    rescue RestClient::ExceptionWithResponse => e
      return  e.response
    end
  end
end

class ClientFactory
  @@instance = ClientFactory.new

  def setInstance(clientFactory)
    @instance = clientFactory
  end

  def self.getInstance
    @@instance
  end

  def createClient
    Client.new
  end

  private_class_method :new
end

