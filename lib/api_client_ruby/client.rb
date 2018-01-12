
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

    def setInstance(clientFactory)
      @singleton_instance = clientFactory
    end

    def self.getInstance
      if @singleton_instance == nil
        @singleton_instance = ClientFactory.new
      end
      @singleton_instance
    end

    def createClient
      Client.new
    end
  end

