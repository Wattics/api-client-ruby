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
    Thread.new do
      sleep 0.01 while @waitSemaphore.available_permits != 0
    end.join
  end

  def startProcessorFeeder
    @agentThreadGroup.add(Thread.new do
      begin
        loop do
          key, values = @enqueuedMeasurementsWithConfig.first
          if @enqueuedMeasurementsWithConfig.empty?
            sleep_fix
            next
          end
          processor = @processorPool.getProcessor(key)
          if processor.nil?
            sleep_fix
            next
          end
          @enqueuedMeasurementsWithConfig.delete(key)
          processor.process(values)
        end
      rescue ThreadError
      end
    end)
  end

  def startMeasurementSentHandlerDispatcher
    @agentThreadGroup.add(Thread.new do
      begin
        loop do
          array = @sentMeasurementsWithContext.pop
          next if array.nil?
          measurement = array[0]
          response = array[1]
          @measurementSentHandlerList.each { |handler| handler.call(measurement, response) }
        end
      rescue ThreadError
      end
    end)
  end

  def sleep_fix
    sleep 0.1
  end

  def send(measurement, config)
    if measurement.is_a?(Array)
      @waitSemaphore.release(measurement.size)
      measurementGroups = measurement.group_by(&:getId)
      measurementGroups.each do |channelId, measurementsForChannelId|
        measurementsWithConfig = measurementsForChannelId.map { |measurement| MeasurementWithConfig.new(measurement, config) }
        @processorAlreadyBoundToChannelId = @processorPool.getProcessor(channelId)
        if @processorAlreadyBoundToChannelId.nil?
          @enqueuedMeasurementsWithConfig[channelId] += measurementsWithConfig
        else
          @processorAlreadyBoundToChannelId.process(measurementsWithConfig)
        end
      end
    else
      @waitSemaphore.release
      measurementWithConfig = MeasurementWithConfig.new(measurement, config)
      @processorAlreadyBoundToChannelId = @processorPool.getProcessor(measurement.getId)
      if @processorAlreadyBoundToChannelId.nil?
        @enqueuedMeasurementsWithConfig[measurement.getId] << measurementWithConfig
      else
        @processorAlreadyBoundToChannelId.process(measurementWithConfig)
      end
    end
  end

  def reportSentMeasurement(measurement, response)
    @sentMeasurementsWithContext << [measurement, response]
    @waitSemaphore.acquire
  end

  def addMeasurementSentHandler
    @measurementSentHandlerList << yield
  end
end
