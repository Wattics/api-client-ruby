require 'json'
require 'time'

class Measurement
  attr_accessor :id, :timestamp

  def timestamp=(time)
    @timestamp = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
  end

  def <=>(measurement)
    @timestamp <=> measurement.timestamp
  end

end

class SimpleMeasurement < Measurement
  attr_accessor :value

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
  attr_accessor :id, :active_power_phase_a, :active_power_phase_b, :active_power_phase_c,
                :reactive_power_phase_a, :reactive_power_phase_b, :reactive_power_phase_c,
                :apparent_power_phase_a, :apparent_power_phase_b, :apparent_power_phase_c,
                :voltage_phase_a, :voltage_phase_b, :voltage_phase_c,
                :current_phase_a, :current_phase_b, :current_phase_c,
                :active_energy_phase_a, :active_energy_phase_b, :active_energy_phase_c,
                :line_to_line_voltage_phase_ab, :line_to_line_voltage_phase_bc, :line_to_line_voltage_phase_ac

  def to_s
    'ElectricityMeasurement{' \
      "id='" + @id.to_s + '\'' \
      ', timestamp=' + @timestamp.to_s +
      ', active_power_phase_a=' + @active_power_phase_a.to_s +
      ', active_power_phase_b=' + @active_power_phase_b.to_s +
      ', active_power_phase_c=' + @active_power_phase_c.to_s +
      ', reactive_power_phase_a=' + @reactive_power_phase_a.to_s +
      ', reactive_power_phase_b=' + @reactive_power_phase_b.to_s +
      ', reactive_power_phase_c=' + @reactive_power_phase_c.to_s +
      ', apparent_power_phase_a=' + @apparent_power_phase_a.to_s +
      ', apparent_power_phase_b=' + @apparent_power_phase_b.to_s +
      ', apparent_power_phase_c=' + @apparent_power_phase_c.to_s +
      ', voltage_phase_a=' + @voltage_phase_a.to_s +
      ', voltage_phase_b=' + @voltage_phase_b.to_s +
      ', voltage_phase_c=' + @voltage_phase_c.to_s +
      ', current_phase_a=' + @current_phase_a.to_s +
      ', current_phase_b=' + @current_phase_b.to_s +
      ', current_phase_c=' + @current_phase_c.to_s +
      ', active_energy_phase_a=' + @active_energy_phase_a.to_s +
      ', active_energy_phase_b=' + @active_energy_phase_b.to_s +
      ', active_energy_phase_c=' + @active_energy_phase_c.to_s +
      ', line_to_line_voltage_phase_ab=' + @line_to_line_voltage_phase_ab.to_s +
      ', line_to_line_voltage_phase_ac=' + @line_to_line_voltage_phase_ac.to_s +
      ', line_to_line_voltage_phase_bc=' + @line_to_line_voltage_phase_bc.to_s +
      '}'
  end

  def json
    {
      id: @id.to_s,
      tsISO8601: @timestamp,
      aP_1: @active_power_phase_a,
      aP_2: @active_power_phase_b,
      aP_3: @active_power_phase_c,
      rP_1: @reactive_power_phase_a,
      rP_2: @reactive_power_phase_b,
      rP_3: @reactive_power_phase_c,
      apP_1: @apparent_power_phase_a,
      apP_2: @apparent_power_phase_b,
      apP_3: @apparent_power_phase_c,
      v_1: @voltage_phase_a,
      v_2: @voltage_phase_b,
      v_3: @voltage_phase_c,
      c_1: @current_phase_a,
      c_2: @current_phase_b,
      c_3: @current_phase_c,
      pC_1: @active_energy_phase_a,
      pC_2: @active_energy_phase_b,
      pC_3: @active_energy_phase_c,
      v_12: @line_to_line_voltage_phase_ab,
      v_13: @line_to_line_voltage_phase_ac,
      v_23: @line_to_line_voltage_phase_bc
    }.select { |_k, v| v }.to_json
  end
end
