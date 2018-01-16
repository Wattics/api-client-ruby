require 'concurrent'

class Processor
  def initialize(agent)
    @agent = agent
    @client = ClientFactory.getInstance.createClient
    @measurementsWithConfig = PriorityBlockingQueue.new
    @semaphore = Concurrent::Semaphore.new(0)
    @isSending = false;
    @mutex = Mutex.new
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
          #binding.pry
          begin
            @response = @client.send(@measurement, @config)
            if @agent != nil
              @agent.reportSentMeasurement(@measurement, @response)
            end
            if (@response != nil && @response.code >= 400)
              raise response.response
            end
            # [@response.code, @measurement]
            break
           rescue Exception => e
            @agent.reportSentMeasurement(@measurement, e)
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
