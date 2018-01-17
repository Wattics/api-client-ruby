require 'concurrent'

class Agent
  @@mutex = Mutex.new
  attr_reader :thread
  def initialize(maximumParallelSenders = 0)
    @agentThreadGroup = ThreadGroup.new
    @processorPool = ProcessorPool.new(self, @agentThreadGroup, maximumParallelSenders)
    @enqueuedMeasurementsWithConfig = Hash.new { |h, k| h[k] = [] }
    @sentMeasurementsWithContext = BlockingQueue.new
    @measurementSentHandlerList = Concurrent::Array.new
    startProcessorFeeder
    startMeasurementSentHandlerDispatcher
    @waitSemaphore = Concurrent::Semaphore.new(0)
    @start = false
  end
  private_class_method :new

  def self.getInstance(maximumParallelSenders = 0)
    @@mutex.synchronize do
      @@instance ||= new(maximumParallelSenders)
    end
  end

  def self.dispose
    @@mutex.synchronize do
      unless @@instance.nil?
        @@instance.agentThreadGroup.list.each(&:kill)
        @@instance = nil
      end
    end
  end

  def waitUntilLast
    @start = true
    @thread = Thread.new {
      while @waitSemaphore.available_permits != 0
        sleep 0.01
      end
    }
  end

  def startProcessorFeeder
    @agentThreadGroup.add(Thread.new do
      begin
        loop do
          key, values = enqueuedMeasurementsWithConfig.first
          if enqueuedMeasurementsWithConfig.empty?
            sleep_fix
            next
          end
          processor = @processorPool.getProcessor(key)
          if processor.nil?
            sleep_fix
            next
          end
          enqueuedMeasurementsWithConfig.delete(key)
          processor.process(values)
        end
      rescue ThreadError
      end
    end )
  end

  def startMeasurementSentHandlerDispatcher
    @agentThreadGroup.add(Thread.new do
      begin
        loop do
          array = @sentMeasurementsWithContext.pop
          measurement = array[0]
          response = array[1]
          @measurementSentHandlerList.call(measurement, response)
        end
      rescue ThreadError
      end
    end)
  end

  def sleep_fix
    sleep(0.001)
  end

  def send(measurement, config)
    if measurement.is_a?(Array)
      @waitSemaphore.release(measurement.size)
      @start = false
      measurementGroups = measurement.group_by(&:getId)
      measurementGroups.each do |channelId, measurementsForChannelId|
        measurementsWithConfig = measurementsForChannelId.map { |measurement| MeasurementWithConfig.new(measurement, config) }
        @processorAlreadyBoundToChannelId = @processorPool.getProcessor(channelId)
        unless @processorAlreadyBoundToChannelId.nil?
          @processorAlreadyBoundToChannelId.process(measurementsWithConfig)
        else
          @enqueuedMeasurementsWithConfig[channelId] += measurementsWithConfig
        end
      end
    else
      @waitSemaphore.release
      @start = false
      measurementWithConfig = MeasurementWithConfig.new(measurement, config)
      @processorAlreadyBoundToChannelId = @processorPool.getProcessor(measurement.getId)
      unless @processorAlreadyBoundToChannelId.nil?
        @processorAlreadyBoundToChannelId.process(measurementWithConfig)
      else
        @enqueuedMeasurementsWithConfig[measurement.getId] << measurementWithConfig
      end
    end

    unless @start
      waitUntilLast
      @thread.join
    end

  end

  def reportSentMeasurement(measurement, response)
    @sentMeasurementsWithContext << [measurement, response]
    @waitSemaphore.acquire
  end

  def addMeasurementSentHandler(&block)
    @measurementSentHandlerList = yield
  end
end

