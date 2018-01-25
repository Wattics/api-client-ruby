require 'concurrent'

class Agent
  @@mutex = Mutex.new
  attr_reader :thread
  def initialize(maximum_parallel_senders = 0)
    @agent_thread_group = ThreadGroup.new
    @processor_pool = ProcessorPool.new(self, @agent_thread_group, maximum_parallel_senders)
    @enqueued_measurements_with_config = Hash.new { |h, k| h[k] = [] }
    @sent_measurements_with_context = BlockingQueue.new
    @measurement_sent_handler_list = Concurrent::Array.new
    start_processor_feeder
    start_measurement_sent_handler_dispatcher
    @wait_semaphore = Concurrent::Semaphore.new(0)
  end
  private_class_method :new

  def self.get_instance(maximum_parallel_senders = 0)
    @@mutex.synchronize do
      @@instance ||= new(maximum_parallel_senders)
    end
  end

  def self.dispose
    @@mutex.synchronize do
      unless @@instance.nil?
        @@instance.agent_thread_group.list.each(&:kill)
        @@instance = nil
      end
    end
  end

  def wait_until_last
    Thread.new do
      sleep 0.01 while @wait_semaphore.available_permits != 0
    end.join
  end

  def start_processor_feeder
    @agent_thread_group.add(Thread.new do
      begin
        loop do
          key, values = @enqueued_measurements_with_config.first
          if @enqueued_measurements_with_config.empty?
            sleep_fix
            next
          end
          processor = @processor_pool.get_processor(key)
          if processor.nil?
            sleep_fix
            next
          end
          @enqueued_measurements_with_config.delete(key)
          processor.process(values)
        end
      rescue ThreadError
      end
    end)
  end

  def start_measurement_sent_handler_dispatcher
    @agent_thread_group.add(Thread.new do
      begin
        loop do
          array = @sent_measurements_with_context.pop
          next if array.nil?
          measurement = array[0]
          response = array[1]
          @measurement_sent_handler_list.each { |handler| handler.call(measurement, response) }
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
      @wait_semaphore.release(measurement.size)
      measurement_groups = measurement.group_by(&:getId)
      measurement_groups.each do |channel_id, measurements_for_channel_id|
        measurements_with_config = measurements_for_channel_id.map { |measurement| MeasurementWithConfig.new(measurement, config) }
        @processor_already_bound_to_channel_id = @processor_pool.get_processor(channel_id)
        if @processor_already_bound_to_channel_id.nil?
          @enqueued_measurements_with_config[channel_id] += measurements_with_config
        else
          @processor_already_bound_to_channel_id.process(measurements_with_config)
        end
      end
    else
      @wait_semaphore.release
      measurement_with_config = MeasurementWithConfig.new(measurement, config)
      @processor_already_bound_to_channel_id = @processor_pool.get_processor(measurement.getId)
      if @processor_already_bound_to_channel_id.nil?
        @enqueued_measurements_with_config[measurement.getId] << measurement_with_config
      else
        @processor_already_bound_to_channel_id.process(measurement_with_config)
      end
    end
  end

  def report_sent_measurement(measurement, response)
    @sent_measurements_with_context << [measurement, response]
    @wait_semaphore.acquire
  end

  def add_measurement_sent_handler
    @measurement_sent_handler_list << yield
  end
end
