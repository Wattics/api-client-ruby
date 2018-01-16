
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
        @@instance ||= new(maximumParallelSenders)
      end
    end

    def dispose
      @@mutex.synchronize do
        unless @@instance.nil?
          @@instance.agentThreadGroup.list.each { |thread| thread.kill }
          @@instance = nil
        end
      end
    end

    def startProcessorFeeder
      @agentThreadGroup.add( Thread.new {
        begin
          loop do
            key, values = enqueuedMeasurementsWithConfig.first
            if enqueuedMeasurementsWithConfig.empty?
              sleep_fix
              next
            end
            processor = @processorPool.getProcessor(key);
            if processor.nil?
              sleep_fix
              next
            end
            enqueuedMeasurementsWithConfig.delete(key)
            processor.process(values);
          end
        rescue ThreadError
        end
      })
    end

    def startMeasurementSentHandlerDispatcher
    @agentThreadGroup.add( Thread.new {
      begin
        loop do
          array = @sentMeasurementsWithContext.pop
          measurement = array[0]
          response = array[1]
          #@measurementSentHandlerList = (r) -> { }
          addMeasurementSentHandler(measurement,response)
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
        measurementGroups =  measurement.group_by{ |measurement| measurement.getId }
        measurementGroups.each do |channelId, measurementsForChannelId|
          measurementsWithConfig =  measurementsForChannelId.map { |measurement| MeasurementWithConfig.new(measurement, config) }
          @processorAlreadyBoundToChannelId = @processorPool.getProcessor(channelId)
          unless @processorAlreadyBoundToChannelId.nil?
            @processorAlreadyBoundToChannelId.process(measurementsWithConfig)
          else
            @enqueuedMeasurementsWithConfig[channelId] += measurementsWithConfig
          end
        end

      else
        measurementWithConfig = MeasurementWithConfig.new(measurement, config)
        @processorAlreadyBoundToChannelId = @processorPool.getProcessor(measurement.getId)
        unless @processorAlreadyBoundToChannelId.nil?
          @processorAlreadyBoundToChannelId.process(measurementWithConfig)
        else
          @enqueuedMeasurementsWithConfig[measurement.getId] << measurementWithConfig
        end
      end

      if @sentMeasurementsWithContext.isEmpty? #wait until there is at least one callback to get threads going
        sleep 0.1
      end
    end

    def reportSentMeasurement(measurement, response)
      @sentMeasurementsWithContext << [measurement, response]
      # if @sentMeasurementsWithContext.isEmpty?
      #   sleep 1
      #   next
      # end
    end

    def addMeasurementSentHandler

    end
  end

