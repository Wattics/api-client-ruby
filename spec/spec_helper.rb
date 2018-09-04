require 'bundler/setup'
require 'wattics-api-client'
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
  attr_accessor :id, :timestamp, :value
  private_class_method :new

  def self.get_instance
    @instance ||= new
  end

  def build
    simple_measurement = SimpleMeasurement.new
    simple_measurement.id = id
    simple_measurement.timestamp = timestamp
    simple_measurement.value = value
    simple_measurement
  end

  def id
    @id ||= SecureRandom.uuid
  end

  def timestamp
    @timestamp ||= Time.now
  end

  def value
    @value ||= rand
  end

end

class ElectricityMeasurementFactory
  attr_accessor :id, :active_power_phase_a, :active_power_phase_b, :active_power_phase_c,
                :reactive_power_phase_a, :reactive_power_phase_b, :reactive_power_phase_c,
                :apparent_power_phase_a, :apparent_power_phase_b, :apparent_power_phase_c,
                :voltage_phase_a, :voltage_phase_b, :voltage_phase_c,
                :current_phase_a, :current_phase_b, :current_phase_c,
                :active_energy_phase_a, :active_energy_phase_b, :active_energy_phase_c,
                :line_to_line_voltage_phase_ab, :line_to_line_voltage_phase_bc, :line_to_line_voltage_phase_ac

  private_class_method :new

  def self.get_instance
    @instance ||= new
  end

  def build
    electricity_measurement = ElectricityMeasurement.new

    electricity_measurement.id = id
    electricity_measurement.timestamp = timestamp
    electricity_measurement.active_power_phase_a = active_power_phase_a
    electricity_measurement.active_power_phase_b = active_power_phase_b
    electricity_measurement.active_power_phase_c = active_power_phase_c
    electricity_measurement.reactive_power_phase_a = reactive_power_phase_a
    electricity_measurement.reactive_power_phase_b = reactive_power_phase_b
    electricity_measurement.reactive_power_phase_c = reactive_power_phase_c
    electricity_measurement.apparent_power_phase_a = apparent_power_phase_a
    electricity_measurement.apparent_power_phase_b = apparent_power_phase_b
    electricity_measurement.apparent_power_phase_c = apparent_power_phase_c
    electricity_measurement.voltage_phase_a = voltage_phase_a
    electricity_measurement.voltage_phase_b = voltage_phase_b
    electricity_measurement.voltage_phase_c = voltage_phase_c
    electricity_measurement.current_phase_a = current_phase_a
    electricity_measurement.current_phase_b = current_phase_b
    electricity_measurement.current_phase_c = current_phase_c
    electricity_measurement.active_energy_phase_a = active_energy_phase_a
    electricity_measurement.active_energy_phase_b = active_energy_phase_b
    electricity_measurement.active_energy_phase_c = active_energy_phase_c
    electricity_measurement.line_to_line_voltage_phase_ab = line_to_line_voltage_phase_ab
    electricity_measurement.line_to_line_voltage_phase_ac = line_to_line_voltage_phase_ac
    electricity_measurement.line_to_line_voltage_phase_bc = line_to_line_voltage_phase_bc
    electricity_measurement
  end

  def id
    @id ||= SecureRandom.uuid
  end

  def timestamp
    @timestamp ||= Time.now
  end

  def active_power_phase_a
    @active_power_phase_a ||= rand
  end

  def active_power_phase_b
    @active_power_phase_b ||= rand
  end

  def active_power_phase_c
    @active_power_phase_c ||= rand
  end

  def reactive_power_phase_a
    @reactive_power_phase_a ||= rand
  end

  def reactive_power_phase_b
    @reactive_power_phase_b ||= rand
  end

  def reactive_power_phase_c
    @reactive_power_phase_c ||= rand
  end

  def apparent_power_phase_a
    @apparent_power_phase_a ||= rand
  end


  def apparent_power_phase_b
    @apparent_power_phase_b ||= rand
  end


  def apparent_power_phase_c
    @apparent_power_phase_c ||= rand
  end


  def voltage_phase_a
    @voltage_phase_a ||= rand
  end


  def voltage_phase_b
    @voltage_phase_b ||= rand
  end

  def voltage_phase_c
    @voltage_phase_c ||= rand
  end

  def current_phase_a
    @current_phase_a ||= rand
  end

  def current_phase_b
    @current_phase_b ||= rand
  end

  def current_phase_c
    @current_phase_c ||= rand
  end

  def active_energy_phase_a
    @active_energy_phase_a ||= rand
  end

  def active_energy_phase_b
    @active_energy_phase_c ||= rand
  end

  def active_energy_phase_c
    @activeEnergyPhaseC ||= rand
  end

  def line_to_line_voltage_phase_ab
    @line_to_line_voltage_phase_ab ||= rand
  end

  def line_to_line_voltage_phase_ac
    @line_to_line_voltage_phase_ac ||= rand
  end

  def line_to_line_voltage_phase_bc
    @line_to_line_voltage_phase_bc ||= rand
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

class MockResponse500
  def code
    500
  end
  def body
    "error"
  end
end
