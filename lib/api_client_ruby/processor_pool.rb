
  class ProcessorPool
    attr_reader :processors
    def initialize(agent, agentThreadGroup, maximumParallelSenders = 0)
      maximumParallelSenders > 0 ? @max_processors = maximumParallelSenders.freeze : @max_processors = (2 * Concurrent.processor_count).freeze
      @agent = agent
      @processors = {}
      @processorThreadGroup = agentThreadGroup
      @mutex = Mutex.new

    end

    def getProcessor(channelId)
      @mutex.synchronize do
        processor = @processors[channelId]
        return processor unless @processor.nil?
        if @processors.size < @max_processors
          @processors[channelId] = spawnNewProcessor
          @processors[channelId]
        else
          rebindProcessorToChannelId(channelId)
        end
      end
    end

    private

    def spawnNewProcessor
      processor = Processor.new(@agent)
      @processorThreadGroup.add( Thread.new { processor.run } )
      processor
    end

    def rebindProcessorToChannelId(newChannelId)
      idleProcessorEntry = @processors.select { |key, value| value.isIdle? }.first

      return nil if idleProcessorEntry.nil?

      oldChannelId = idleProcessorEntry[0]
      idleProcessor = idleProcessorEntry[1]
      @processors.delete(oldChannelId)
      @processors[newChannelId] = idleProcessor
      idleProcessor
    end
  end
