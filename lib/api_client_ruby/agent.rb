
  class Agent
    @@mutex = Mutex.new

    attr_reader :sentMeasurementsWithContext

    def initialize(maximumParallelSenders = 0)
      @agentThreadGroup = ThreadGroup.new
      @processorPool = ProcessorPool.new(self, @agentThreadGroup, maximumParallelSenders)
      @enqueuedMeasurementsWithConfig = Hash.new { |h,k| h[k] = [] }
      @sentMeasurementsWithContext = BlockingQueue.new
      @measurementSentHandlerList = []
      startProcessorFeeder
      startMeasurementSentHandlerDispatcher
    end

    def self.getInstance(maximumParallelSenders=0)
      @@mutex.synchronize do
        if @singleton_instance == nil
          @singleton_instance = Agent.new(maximumParallelSenders)
        end
        return @singleton_instance
      end
    end

    def dispose
      @@mutex.synchronize do
        unless @singleton_instance.nil?
          @singleton_instance.agentThreadGroup.list.each { |thread| thread.kill }
          @singleton_instance = nil
        end
      end
    end

    def startProcessorFeeder
      @agentThreadGroup.add( Thread.new {
        begin
          loop do
            # have to implement an iterator
            # iterator = enqueuedMeasurementsWithConfig.each { |key| enqueuedMeasurementsWithConfig[key].each{ |measurementsWithConfig| measurementsWithConfig }}
            # implement hasNext
            # next unless iterator.hasNext
            # sleep_fix

            # channelId = iterator.next

            # processor = @processorPool.getProcessor(channelId)

            # next if processor.nil?
            # sleep_fix

          end
        rescue ThreadError
        end
      })
    end

    def startMeasurementSentHandlerDispatcher
      @agentThreadGroup.add( Thread.new {
        begin
          loop do
            # array = @sentMeasurementsWithContext.pop
            # measurement = array[0]
            # response = array[1]
            #response.code
            #@measurementSentHandlerList.each { |measurementSentHandler| }
          end
        rescue ThreadError
        end
        })
    end

    def sleep_fix
      sleep(100)
    end

    def send(measurement, config)
      if measurement.kind_of?(Array)
      else
        measurementWithConfig = MeasurementWithConfig.new(measurement, config)
        @processorAlreadyBoundToChannelId = @processorPool.getProcessor(measurement.getId)

        #binding.pry
        unless @processorAlreadyBoundToChannelId.nil?
          @processorAlreadyBoundToChannelId.process(measurementWithConfig)
        else
          @enqueuedMeasurementsWithConfig[measurement.getId] << measurementWithConfig
        end
        #binding.pry
      end

    end

    def reportSentMeasurement(measurement, response)
      @sentMeasurementsWithContext << [measurement, response]
    end

    def addMeasurementSentHandler

    end
  end

