require 'bundler/setup'
require 'api_client_ruby'
require 'securerandom'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class SimpleMeasurementFactory
  @@instance = new

  def initialize
    @id
    @timestamp
    @value
  end

  private_class_method :new

  def self.getInstance
    @@instance
  end

  def build
    simpleMeasurement = SimpleMeasurement.new
    simpleMeasurement.setId(getId)
    simpleMeasurement.setTimestamp(getTimestamp)
    simpleMeasurement.setValue(getValue)
    simpleMeasurement
  end

  def getId
    @id ||= SecureRandom.uuid
  end

  def setId(id)
    @id = id
  end

  def getTimestamp
    @timestamp ||= Time.now
  end

  def setTimestamp(timestamp)
    @timestamp = timestamp
  end

  def getValue
    @value ||= rand
  end

  def setValue(value)
    @value = value
  end
end

class ElectricityMeasurementFactory
  @@instance = new

  def initialize
    @id
    @timestamp
    @activePowerPhaseA
    @activePowerPhaseB
    @activePowerPhaseC
    @reactivePowerPhaseA
    @reactivePowerPhaseB
    @reactivePowerPhaseC
    @apparentPowerPhaseA
    @apparentPowerPhaseB
    @apparentPowerPhaseC
    @voltagePhaseA
    @voltagePhaseB
    @voltagePhaseC
    @currentPhaseA
    @currentPhaseB
    @currentPhaseC
    @activeEnergyPhaseA
    @activeEnergyPhaseB
    @activeEnergyPhaseC
    @lineToLineVoltagePhaseAB
    @lineToLineVoltagePhaseBC
    @lineToLineVoltagePhaseAC
  end

  private_class_method :new

  def self.getInstance
    @@instance
  end

  def build
    electricityMeasurement = ElectricityMeasurement.new
    electricityMeasurement.setId(getId)
    electricityMeasurement.setTimestamp(getTimestamp)
    electricityMeasurement.setActivePowerPhaseA(getActivePowerPhaseA)
    electricityMeasurement.setActivePowerPhaseB(getActivePowerPhaseB)
    electricityMeasurement.setActivePowerPhaseC(getActivePowerPhaseC)
    electricityMeasurement.setReactivePowerPhaseA(getReactivePowerPhaseA)
    electricityMeasurement.setReactivePowerPhaseB(getReactivePowerPhaseB)
    electricityMeasurement.setReactivePowerPhaseC(getReactivePowerPhaseC)
    electricityMeasurement.setApparentPowerPhaseA(getApparentPowerPhaseA)
    electricityMeasurement.setApparentPowerPhaseB(getApparentPowerPhaseB)
    electricityMeasurement.setApparentPowerPhaseC(getApparentPowerPhaseC)
    electricityMeasurement.setVoltagePhaseA(getVoltagePhaseA)
    electricityMeasurement.setVoltagePhaseB(getVoltagePhaseB)
    electricityMeasurement.setVoltagePhaseC(getVoltagePhaseC)
    electricityMeasurement.setCurrentPhaseA(getCurrentPhaseA)
    electricityMeasurement.setCurrentPhaseB(getCurrentPhaseB)
    electricityMeasurement.setCurrentPhaseC(getCurrentPhaseC)
    electricityMeasurement.setActiveEnergyPhaseA(getActiveEnergyPhaseA)
    electricityMeasurement.setActiveEnergyPhaseB(getActiveEnergyPhaseB)
    electricityMeasurement.setActiveEnergyPhaseC(getActiveEnergyPhaseC)
    electricityMeasurement.setLineToLineVoltagePhaseAB(getLineToLineVoltagePhaseAB)
    electricityMeasurement.setLineToLineVoltagePhaseAC(getLineToLineVoltagePhaseAC)
    electricityMeasurement.setLineToLineVoltagePhaseBC(getLineToLineVoltagePhaseBC)
    electricityMeasurement
  end

  def getId
    @id ||= SecureRandom.uuid
  end

  def setId(id)
    @id = id
  end

  def getTimestamp
    @timestamp ||= Time.now
  end

  def setTimestamp(timestamp)
    @timestamp = timestamp
  end

  def getActivePowerPhaseA
    @activePowerPhaseA ||= rand
  end

  def setActivePowerPhaseA(activePowerPhaseA)
    @activePowerPhaseA = activePowerPhaseA
  end

  def getActivePowerPhaseB
    @activePowerPhaseB ||= rand
  end

  def setActivePowerPhaseB(activePowerPhaseB)
    @activePowerPhaseB = activePowerPhaseB
  end

  def getActivePowerPhaseC
    @activePowerPhaseC ||= rand
  end

  def setActivePowerPhaseC(_activePowerPhaseC)
    @activePowerPhaseC = ActivePowerPhaseC
  end

  def getReactivePowerPhaseA
    @reactivePowerPhaseA ||= rand
  end

  def setReactivePowerPhaseA(reactivePowerPhaseA)
    @reactivePowerPhaseA = reactivePowerPhaseA
  end

  def getReactivePowerPhaseB
    @reactivePowerPhaseB ||= rand
  end

  def setReactivePowerPhaseB(reactivePowerPhaseB)
    @reactivePowerPhaseB = reactivePowerPhaseB
  end

  def getReactivePowerPhaseC
    @reactivePowerPhaseC ||= rand
  end

  def setReactivePowerPhaseC(reactivePowerPhaseC)
    @reactivePowerPhaseC = reactivePowerPhaseC
  end

  def getApparentPowerPhaseA
    @apparentPowerPhaseA ||= rand
  end

  def setApparentPowerPhaseA(apparentPowerPhaseA)
    @apparentPowerPhaseA = apparentPowerPhaseA
  end

  def getApparentPowerPhaseB
    @apparentPowerPhaseB ||= rand
  end

  def setApparentPowerPhaseB(apparentPowerPhaseB)
    @apparentPowerPhaseB = apparentPowerPhaseB
  end

  def getApparentPowerPhaseC
    @apparentPowerPhaseC ||= rand
  end

  def setApparentPowerPhaseC(apparentPowerPhaseC)
    @apparentPowerPhaseC = apparentPowerPhaseC
  end

  def getVoltagePhaseA
    @voltagePhaseA ||= rand
  end

  def setVoltagePhaseA(voltagePhaseA)
    @voltagePhaseA = voltagePhaseA
  end

  def getVoltagePhaseB
    @voltagePhaseB ||= rand
  end

  def setVoltagePhaseB(voltagePhaseB)
    @voltagePhaseB = voltagePhaseB
  end

  def getVoltagePhaseC
    @voltagePhaseC ||= rand
  end

  def setVoltagePhaseC(voltagePhaseC)
    @voltagePhaseC = voltagePhaseC
  end

  def getCurrentPhaseA
    @currentPhaseA ||= rand
  end

  def setCurrentPhaseA(currentPhaseA)
    @currentPhaseA = currentPhaseA
  end

  def getCurrentPhaseB
    @currentPhaseB ||= rand
  end

  def setCurrentPhaseB(currentPhaseB)
    @currentPhaseB = currentPhaseB
  end

  def getCurrentPhaseC
    @currentPhaseC ||= rand
  end

  def setCurrentPhaseC(currentPhaseC)
    @currentPhaseC = currentPhaseC
  end

  def getActiveEnergyPhaseA
    @activeEnergyPhaseA ||= rand
  end

  def setActiveEnergyPhaseA(activeEnergyPhaseA)
    @activeEnergyPhaseA = activeEnergyPhaseA
  end

  def getActiveEnergyPhaseB
    @activeEnergyPhaseB ||= rand
  end

  def setActiveEnergyPhaseB(activeEnergyPhaseB)
    @activeEnergyPhaseB = activeEnergyPhaseB
  end

  def getActiveEnergyPhaseC
    @activeEnergyPhaseC ||= rand
  end

  def setActiveEnergyPhaseC(activeEnergyPhaseC)
    @activeEnergyPhaseC = activeEnergyPhaseC
  end

  def getLineToLineVoltagePhaseAB
    @lineToLineVoltagePhaseAB ||= rand
  end

  def setLineToLineVoltagePhaseAB(lineToLineVoltagePhaseAB)
    @lineToLineVoltagePhaseAB = lineToLineVoltagePhaseAB
  end

  def getLineToLineVoltagePhaseAC
    @lineToLineVoltagePhaseAC ||= rand
  end

  def setLineToLineVoltagePhaseAC(lineToLineVoltagePhaseAC)
    @lineToLineVoltagePhaseAC = lineToLineVoltagePhaseAC
  end

  def getLineToLineVoltagePhaseBC
    @lineToLineVoltagePhaseBC ||= rand
  end

  def setLineToLineVoltagePhaseBC(_lineToLineVoltagePhaseBC)
    @lineToLineVoltagePhaseBC = getLineToLineVoltagePhaseBC
  end
end

class MockClient < Client
  def send(_measurement, _config)
    MockResponse.new
  end
end

class MockResponse
  def code
    200
  end
end
