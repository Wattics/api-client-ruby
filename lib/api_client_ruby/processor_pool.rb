class ProcessorPool
  # attr_reader :processors
  def initialize(agent, agent_thread_group, maximum_parallel_senders = 0)
    maximum_parallel_senders > 0 ? @max_processors = maximum_parallel_senders.freeze : @max_processors = (2 * Concurrent.processor_count).freeze
    @agent = agent
    @processors = {}
    @processor_thread_group = agent_thread_group
    @mutex = Mutex.new
  end

  def get_processor(channel_id)
    @mutex.synchronize do
      processor = @processors[channel_id]
      return processor unless processor.nil?
      if @processors.size < @max_processors
        @processors[channel_id] = spawn_new_processor
        @processors[channel_id]
      else
        rebind_processor_to_channel_id(channel_id)
      end
    end
  end

  private

  def spawn_new_processor
    processor = Processor.new(@agent)
    @processor_thread_group.add(Thread.new { processor.run })
    processor
  end

  def rebind_processor_to_channel_id(new_channel_id)
    idle_processor_entry = @processors.select { |_key, value| value.is_idle? }.first
    return nil if idle_processor_entry.nil?
    old_channel_id = idle_processor_entry[0]
    idle_processor = idle_processor_entry[1]
    @processors.delete(old_channel_id)
    @processors[new_channel_id] = idle_processor
    idle_processor
  end
end
