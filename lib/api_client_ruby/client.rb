require 'rest-client'

class Client
  def send(measurement, config)
    response = RestClient::Request.execute(method: :post, url: config.getUri,
                                           user: config.getUsername, password: config.getPassword,
                                           payload: measurement.json, timeout: 2)
    return response
  rescue RestClient::ExceptionWithResponse => e
    return  e.response
  end
end

class ClientFactory
  def self.setInstance(clientFactory)
    @@instance = clientFactory
  end

  def self.getInstance
    @@instance ||= new
  end

  def createClient
    Client.new
  end

  private_class_method :new
end
