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
      @received.wait(@mutex) while is_empty?
      @queue.shift
    end
  end

  def is_empty?
    @queue.empty?
  end
end

class PriorityBlockingQueue < BlockingQueue
  def <<(x)
    @mutex.synchronize do
      @queue << x
      @queue.flatten!
      @queue.sort!
      @received.signal
    end
  end
end
