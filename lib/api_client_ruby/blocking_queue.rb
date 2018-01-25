class BlockingQueue
  def initialize
    @mutex = Mutex.new
    @queue = []
    @received = ConditionVariable.new
  end

  def <<(x)
    @mutex.synchronize do
      @queue << x
      @received.signal
    end
  end

  def pop
    @mutex.synchronize do
      @received.wait(@mutex) while isEmpty?
      @queue.shift
    end
  end

  def isEmpty?
    @queue.empty?
  end
end

class PriorityBlockingQueue < BlockingQueue
  def <<(x)
    @mutex.synchronize do
      @queue << x
      @queue.flatten!
      @queue.sort_by { |x| x.getMeasurement.timestamp }
      @received.signal
    end
  end
end
