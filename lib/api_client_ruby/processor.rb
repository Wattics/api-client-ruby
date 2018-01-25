require 'concurrent'
require 'nokogiri'

class Processor
  def initialize(agent)
    @agent = agent
    @client = ClientFactory.getInstance.createClient
    @measurementsWithConfig = PriorityBlockingQueue.new
    @semaphore = Concurrent::Semaphore.new(0)
    @isSending = false;
    @mutex = Mutex.new
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::WARN
  end

  def process(measurementWithConfig)
    @measurementsWithConfig << measurementWithConfig
    if measurementWithConfig.kind_of?(Array)
      @semaphore.release(measurementWithConfig.size)
    else
      @semaphore.release
    end
  end

  def isIdle?
    @mutex.synchronize do
      @measurementsWithConfig.isEmpty? && !@isSending
    end
  end

  def run
    begin
      loop do
        @semaphore.acquire
        @mutex.synchronize do
          @measurementWithConfig = @measurementsWithConfig.pop
          @isSending = true
        end
        @measurement = @measurementWithConfig.getMeasurement
        @config = @measurementWithConfig.getConfig
        loop do
          begin
            @response = @client.send(@measurement, @config)
            if (@agent != nil && @response.code < 400)
              @agent.reportSentMeasurement(@measurement, @response)
            end
            if (@agent != nil && @response.code >= 400)
              @logger.error("Could not send #{@measurement}, Server Response: #{Nokogiri::HTML(@response.body).xpath("//h1").text}")
            end
            break
           rescue Exception => e
            @logger.error("Could not send #{@measurement}, Server Response: #{e.response.code}")
            sleep 60
          end
        end
        @mutex.synchronize do
          @isSending = false
        end
      end
    rescue Exception => e
    end
  end
end
