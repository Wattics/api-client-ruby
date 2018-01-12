
  class MeasurementWithConfig
    attr_reader :measurement
    def initialize(measurement, config)
      @measurement = measurement
      @config = config
    end

    def getMeasurement
      @measurement
    end

    def setMeasurement
      @measurement = measurement
    end

    def getConfig
      @config
    end

    def setConfig
      @config = config
    end

    def <=>(measurementWithConfig)
      @measurement <=> (measurementWithConfig.measurement)
    end
  end
