class MeasurementWithConfig
  attr_accessor :measurement, :config
  def initialize(measurement, config)
    @measurement = measurement
    @config = config
  end

  def <=>(measurementWithConfig)
    @measurement <=> measurementWithConfig.measurement
  end
end
