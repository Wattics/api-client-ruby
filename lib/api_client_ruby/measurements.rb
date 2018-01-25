require 'json'
require 'time'

class Measurement
  attr_reader :timestamp
  def initialize
    @id
    @timestamp
  end

  def getId
    @id
  end

  def setId(id)
    @id = id
  end

  def getTimestamp
    @timestamp
  end

  def setTimestamp(time)
    @timestamp = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
  end

  def <=>(measurement)
    @timestamp <=> measurement.timestamp
  end
end

class SimpleMeasurement < Measurement
  def initialize
    @value
  end

  def getValue
    @value
  end

  def setValue(value)
    @value = value
  end

  def to_s
    'SimpleMeasurement{' \
      "id='" + @id.to_s + '\'' \
      ', timestamp=' + @timestamp.to_s +
      ', value=' + @value.to_s +
      '}'
  end

  def json
    {
      id: @id.to_s,
      tsISO8601: @timestamp,
      value: @value
    }.select { |_k, v| v }.to_json
  end
end

class ElectricityMeasurement < Measurement
  def initialize
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

  def getActivePowerPhaseA
    @activePowerPhaseA
  end

  def setActivePowerPhaseA(activePowerPhaseA)
    @activePowerPhaseA = activePowerPhaseA
  end

  def getActivePowerPhaseB
    @activePowerPhaseB
  end

  def setActivePowerPhaseB(activePowerPhaseB)
    @activePowerPhaseB = activePowerPhaseB
  end

  def getActivePowerPhaseC
    @activePowerPhaseC
  end

  def setActivePowerPhaseC(activePowerPhaseC)
    @activePowerPhaseC = activePowerPhaseC
  end

  def getReactivePowerPhaseA
    @reactivePowerPhaseA
  end

  def setReactivePowerPhaseA(reactivePowerPhaseA)
    @reactivePowerPhaseA = reactivePowerPhaseA
  end

  def getReactivePowerPhaseB
    @reactivePowerPhaseB
  end

  def setReactivePowerPhaseB(reactivePowerPhaseB)
    @reactivePowerPhaseB = reactivePowerPhaseB
  end

  def getReactivePowerPhaseC
    @reactivePowerPhaseC
  end

  def setReactivePowerPhaseC(reactivePowerPhaseC)
    @reactivePowerPhaseC = reactivePowerPhaseC
  end

  attr_reader :getApparentPowerPhaseA

  def setApparentPowerPhaseA(apparentPowerPhaseA)
    @apparentPowerPhaseA = apparentPowerPhaseA
  end

  attr_reader :getApparentPowerPhaseB

  def setApparentPowerPhaseB(apparentPowerPhaseB)
    @apparentPowerPhaseB = apparentPowerPhaseB
  end

  attr_reader :getApparentPowerPhaseC

  def setApparentPowerPhaseC(apparentPowerPhaseC)
    @apparentPowerPhaseC = apparentPowerPhaseC
  end

  def getVoltagePhaseA
    @voltagePhaseA
  end

  def setVoltagePhaseA(voltagePhaseA)
    @voltagePhaseA = voltagePhaseA
  end

  def getVoltagePhaseB
    @voltagePhaseB
  end

  def setVoltagePhaseB(voltagePhaseB)
    @voltagePhaseB = voltagePhaseB
  end

  def getVoltagePhaseC
    @voltagePhaseC
  end

  def setVoltagePhaseC(voltagePhaseC)
    @voltagePhaseC = voltagePhaseC
  end

  def getCurrentPhaseA
    @currentPhaseA
  end

  def setCurrentPhaseA(currentPhaseA)
    @currentPhaseA = currentPhaseA
  end

  def getCurrentPhaseB
    @currentPhaseB
  end

  def setCurrentPhaseB(currentPhaseB)
    @currentPhaseB = currentPhaseB
  end

  def getCurrentPhaseC
    @currentPhaseC
  end

  def setCurrentPhaseC(currentPhaseC)
    @currentPhaseC = currentPhaseC
  end

  def getActiveEnergyPhaseA
    @activeEnergyPhaseA
  end

  def setActiveEnergyPhaseA(activeEnergyPhaseA)
    @activeEnergyPhaseA = activeEnergyPhaseA
  end

  def getActiveEnergyPhaseB
    @activeEnergyPhaseB
  end

  def setActiveEnergyPhaseB(activeEnergyPhaseB)
    @activeEnergyPhaseB = activeEnergyPhaseB
  end

  def getActiveEnergyPhaseC
    @activeEnergyPhaseC
  end

  def setActiveEnergyPhaseC(activeEnergyPhaseC)
    @activeEnergyPhaseC = activeEnergyPhaseC
  end

  def getLineToLineVoltagePhaseAB
    @lineToLineVoltagePhaseAB
  end

  def setLineToLineVoltagePhaseAB(lineToLineVoltagePhaseAB)
    @lineToLineVoltagePhaseAB = lineToLineVoltagePhaseAB
  end

  def getLineToLineVoltagePhaseBC
    @lineToLineVoltagePhaseBC
  end

  def setLineToLineVoltagePhaseBC(lineToLineVoltagePhaseBC)
    @lineToLineVoltagePhaseBC = lineToLineVoltagePhaseBC
  end

  def getLineToLineVoltagePhaseAC
    @lineToLineVoltagePhaseAC
  end

  def setLineToLineVoltagePhaseAC(lineToLineVoltagePhaseAC)
    @lineToLineVoltagePhaseAC = lineToLineVoltagePhaseAC
  end

  def to_s
    'ElectricityMeasurement{' \
      "id='" + @id.to_s + '\'' \
      ', timestamp=' + @timestamp.to_s +
      ', activePowerPhaseA=' + @activePowerPhaseA.to_s +
      ', activePowerPhaseB=' + @activePowerPhaseB.to_s +
      ', activePowerPhaseC=' + @activePowerPhaseC.to_s +
      ', reactivePowerPhaseA=' + @reactivePowerPhaseA.to_s +
      ', reactivePowerPhaseB=' + @reactivePowerPhaseB.to_s +
      ', reactivePowerPhaseC=' + @reactivePowerPhaseC.to_s +
      ', apparentPowerPhaseA=' + @apparentPowerPhaseA.to_s +
      ', apparentPowerPhaseB=' + @apparentPowerPhaseB.to_s +
      ', apparentPowerPhaseC=' + @apparentPowerPhaseC.to_s +
      ', voltagePhaseA=' + @voltagePhaseA.to_s +
      ', voltagePhaseB=' + @voltagePhaseB.to_s +
      ', voltagePhaseC=' + @voltagePhaseC.to_s +
      ', currentPhaseA=' + @currentPhaseA.to_s +
      ', currentPhaseB=' + @currentPhaseB.to_s +
      ', currentPhaseC=' + @currentPhaseC.to_s +
      ', activeEnergyPhaseA=' + @activeEnergyPhaseA.to_s +
      ', activeEnergyPhaseB=' + @activeEnergyPhaseB.to_s +
      ', activeEnergyPhaseC=' + @activeEnergyPhaseC.to_s +
      ', lineToLineVoltagePhaseAB=' + @lineToLineVoltagePhaseAB.to_s +
      ', lineToLineVoltagePhaseBC=' + @lineToLineVoltagePhaseBC.to_s +
      ', lineToLineVoltagePhaseAC=' + @lineToLineVoltagePhaseAC.to_s +
      '}'
  end

  def json
    {
      id: @id.to_s,
      tsISO8601: @timestamp,
      aP_1: @activePowerPhaseA,
      aP_2: @activePowerPhaseB,
      aP_3: @activePowerPhaseC,
      rP_1: @reactivePowerPhaseA,
      rP_2: @reactivePowerPhaseB,
      rP_3: @reactivePowerPhaseC,
      apP_1: @apparentPowerPhaseA,
      apP_2: @apparentPowerPhaseB,
      apP_3: @apparentPowerPhaseC,
      v_1: @voltagePhaseA,
      v_2: @voltagePhaseB,
      v_3: @voltagePhaseC,
      c_1: @currentPhaseA,
      c_2: @currentPhaseB,
      c_3: @currentPhaseC,
      pC_1: @activeEnergyPhaseA,
      pC_2: @activeEnergyPhaseB,
      pC_3: @activeEnergyPhaseC,
      v_12: @lineToLineVoltagePhaseAB,
      v_13: @lineToLineVoltagePhaseAC,
      v_23: @lineToLineVoltagePhaseBC
    }.select { |_k, v| v }.to_json
  end
end
