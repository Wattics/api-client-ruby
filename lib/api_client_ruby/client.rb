require 'rest-client'

class Client
  def send(measurement, config)
    response = RestClient::Request.execute(method: :post, url: config.uri,
                                           user: config.username, password: config.password,
                                           payload: measurement.json, timeout: 2)
    return response
  rescue RestClient::ExceptionWithResponse => e
    return  e.response
  end
end

class ClientFactory
  def self.setInstance(client_factory)
    @instance = client_factory
  end

  def self.get_instance
    @instance ||= new
  end

  def create_client
    Client.new
  end

  private_class_method :new
end
