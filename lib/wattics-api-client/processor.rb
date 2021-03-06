require 'concurrent'
require 'nokogiri'

class Processor
  def initialize(agent)
    @agent = agent
    @measurements_with_config = PriorityBlockingQueue.new
    @semaphore = Concurrent::Semaphore.new(0)
    @is_sending = false
    @mutex = Mutex.new
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::WARN
  end

  def process(measurement_with_config)
    @measurements_with_config << measurement_with_config
    if measurement_with_config.is_a?(Array)
      @semaphore.release(measurement_with_config.size)
    else
      @semaphore.release
    end
  end

  def is_idle?
    @mutex.synchronize do
      @measurements_with_config.is_empty? && !@is_sending
    end
  end

  def run
    client = ClientFactory.get_instance.create_client
    loop do
      @semaphore.acquire
      @mutex.synchronize do
        @measurement_with_config = @measurements_with_config.pop
        @is_sending = true
      end
      @measurement = @measurement_with_config.measurement
      @config = @measurement_with_config.config
      loop do
        begin
          @response = client.send(@measurement, @config)
          if !@agent.nil? && @response.code < 400
            @agent.report_sent_measurement(@measurement, @response)
          end

          if !@agent.nil? && @response.code >= 400
            @agent.report_sent_measurement(@measurement, @response)
            if defined?(Rails).nil?
              @logger.error("Could not send #{@measurement}, Server Response: #{@response.body}")
            else
              Rails.logger.error("Could not send #{@measurement}, Server Response: #{@response.body}")
              puts "Could not send #{@measurement}, Server Response: #{@response.body}"
            end

          end
          break
        rescue StandardError => e

          if defined?(Rails).nil?
            @logger.error("Could not send #{@measurement}, Error: #{e}")
          else
            Rails.logger.error("Could not send #{@measurement}, Error: #{e}")
            puts "Could not send #{@measurement}, Error: #{e}"
          end

          sleep 60
        end
      end
      @mutex.synchronize do
        @is_sending = false
      end
    end
  rescue StandardError => e
    if defined?(Rails).nil?
      @logger.error("Thread stopped unexpectedly: #{e.message}")
    else
      Rails.logger.error("Thread stopped unexpectedly: #{e.message}")
      puts "Thread stopped unexpectedly: #{e.message}"
    end
  end
end
