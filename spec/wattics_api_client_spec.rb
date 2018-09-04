require 'wattics-api-client'
require 'concurrent'
require 'json'
require 'time'
require 'pry-byebug'

RSpec.describe WatticsApiClient do
  before(:all) do
    class ClientFactory
      def create_client
        MockClient.new
      end
    end
  end

  context "with Simple Measurements Attributes and JSON" do
    let(:simple_measurement) { SimpleMeasurement.new }

    it "should set and return id attibute" do
      id = "water-01"
      simple_measurement.id = id
      expect(simple_measurement.id).to eq id
    end

    it "should set and return timestamp attibute" do
      time = Time.now
      wattics_time = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
      simple_measurement.timestamp = time
      expect(simple_measurement.timestamp).to eq wattics_time
    end

    it "should set and return value attibute" do
      value = rand
      simple_measurement.value = value
      expect(simple_measurement.value).to be_equal value
    end

    it "should return correct JSON" do
      id = "water-01"
      value = rand
      time = Time.now
      wattics_time = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
      simple_measurement.id = id
      simple_measurement.value = value
      simple_measurement.timestamp = time
      json = {id: id,
              tsISO8601: wattics_time,
              value: value
              }.to_json
      expect(simple_measurement.json).to eq json
    end
  end

  context "with ElectricityMeasurement Attributes and JSON" do
    let(:electricity_measurement) { ElectricityMeasurement.new }

    it "should set and return id attibute" do
      id = "elec-meter-01"
      electricity_measurement.id = id
      expect(electricity_measurement.id).to eq id
    end

    it "should set and return timestamp attibute" do
      time = Time.now
      wattics_time = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
      electricity_measurement.timestamp = time
      expect(electricity_measurement.timestamp).to eq wattics_time
    end

    it "should set and return active_power_phase_a attibute" do
      active_power_phase_a = rand
      electricity_measurement.active_power_phase_a = active_power_phase_a
      expect(electricity_measurement.active_power_phase_a).to be_equal active_power_phase_a
    end

    it "should set and return active_power_phase_b attibute" do
      active_power_phase_b = rand
      electricity_measurement.active_power_phase_b = active_power_phase_b
      expect(electricity_measurement.active_power_phase_b).to be_equal active_power_phase_b
    end

    it "should set and return active_power_phase_c attibute" do
      active_power_phase_c = rand
      electricity_measurement.active_power_phase_c = active_power_phase_c
      expect(electricity_measurement.active_power_phase_c).to be_equal active_power_phase_c
    end

    it "should set and return reactive_power_phase_a attibute" do
      reactive_power_phase_a = rand
      electricity_measurement.reactive_power_phase_a = reactive_power_phase_a
      expect(electricity_measurement.reactive_power_phase_a).to be_equal reactive_power_phase_a
    end

    it "should set and return reactive_power_phase_b attibute" do
      reactive_power_phase_b = rand
      electricity_measurement.reactive_power_phase_b = reactive_power_phase_b
      expect(electricity_measurement.reactive_power_phase_b).to be_equal reactive_power_phase_b
    end

    it "should set and return reactive_power_phase_c attibute" do
      reactive_power_phase_c = rand
      electricity_measurement.reactive_power_phase_c = reactive_power_phase_c
      expect(electricity_measurement.reactive_power_phase_c).to be_equal reactive_power_phase_c
    end

    it "should set and return apparent_power_phase_a attibute" do
      apparent_power_phase_a = rand
      electricity_measurement.apparent_power_phase_a = apparent_power_phase_a
      expect(electricity_measurement.apparent_power_phase_a).to be_equal apparent_power_phase_a
    end

    it "should set and return apparent_power_phase_b attibute" do
      apparent_power_phase_b = rand
      electricity_measurement.apparent_power_phase_b = apparent_power_phase_b
      expect(electricity_measurement.apparent_power_phase_b).to be_equal apparent_power_phase_b
    end

    it "should set and return apparent_power_phase_c attibute" do
      apparent_power_phase_c = rand
      electricity_measurement.apparent_power_phase_c = apparent_power_phase_c
      expect(electricity_measurement.apparent_power_phase_c).to be_equal apparent_power_phase_c
    end

    it "should set and return voltage_phase_a attibute" do
      voltage_phase_a = rand
      electricity_measurement.voltage_phase_a = voltage_phase_a
      expect(electricity_measurement.voltage_phase_a).to be_equal voltage_phase_a
    end

    it "should set and return voltage_phase_b attibute" do
      voltage_phase_b = rand
      electricity_measurement.voltage_phase_b = voltage_phase_b
      expect(electricity_measurement.voltage_phase_b).to be_equal voltage_phase_b
    end

    it "should set and return voltage_phase_c attibute" do
      voltage_phase_c = rand
      electricity_measurement.voltage_phase_c = voltage_phase_c
      expect(electricity_measurement.voltage_phase_c).to be_equal voltage_phase_c
    end

    it "should set and return current_phase_a attibute" do
      current_phase_a = rand
      electricity_measurement.current_phase_a = current_phase_a
      expect(electricity_measurement.current_phase_a).to be_equal current_phase_a
    end

    it "should set and return current_phase_b attibute" do
      current_phase_b = rand
      electricity_measurement.current_phase_b = current_phase_b
      expect(electricity_measurement.current_phase_b).to be_equal current_phase_b
    end

    it "should set and return current_phase_c attibute" do
      current_phase_c = rand
      electricity_measurement.current_phase_c = current_phase_c
      expect(electricity_measurement.current_phase_c).to be_equal current_phase_c
    end

    it "should set and return active_energy_phase_a attibute" do
      active_energy_phase_a = rand
      electricity_measurement.active_energy_phase_a = active_energy_phase_a
      expect(electricity_measurement.active_energy_phase_a).to be_equal active_energy_phase_a
    end

    it "should set and return active_energy_phase_b attibute" do
      active_energy_phase_b = rand
      electricity_measurement.active_energy_phase_b = active_energy_phase_b
      expect(electricity_measurement.active_energy_phase_b).to be_equal active_energy_phase_b
    end

    it "should set and return active_energy_phase_c attibute" do
      active_energy_phase_c = rand
      electricity_measurement.active_energy_phase_c = active_energy_phase_c
      expect(electricity_measurement.active_energy_phase_c).to be_equal active_energy_phase_c
    end

    it "should set and return line_to_line_voltage_phase_ab attibute" do
      line_to_line_voltage_phase_ab = rand
      electricity_measurement.line_to_line_voltage_phase_ab = line_to_line_voltage_phase_ab
      expect(electricity_measurement.line_to_line_voltage_phase_ab).to be_equal line_to_line_voltage_phase_ab
    end

    it "should set and return line_to_line_voltage_phase_bc attibute" do
      line_to_line_voltage_phase_bc = rand
      electricity_measurement.line_to_line_voltage_phase_bc = line_to_line_voltage_phase_bc
      expect(electricity_measurement.line_to_line_voltage_phase_bc).to be_equal line_to_line_voltage_phase_bc
    end

    it "should set and return line_to_line_voltage_phase_ac attibute" do
      line_to_line_voltage_phase_ac = rand
      electricity_measurement.line_to_line_voltage_phase_ac = line_to_line_voltage_phase_ac
      expect(electricity_measurement.line_to_line_voltage_phase_ac).to be_equal line_to_line_voltage_phase_ac
    end

    it "should return correct JSON" do
      id = "meter-01"
      time = Time.now
      wattics_time = time.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
      active_power_phase_a = rand
      active_power_phase_b = rand
      active_power_phase_c = rand
      reactive_power_phase_a = rand
      reactive_power_phase_b = rand
      reactive_power_phase_c = rand
      apparent_power_phase_a = rand
      apparent_power_phase_b = rand
      apparent_power_phase_c = rand
      voltage_phase_a = rand
      voltage_phase_b = rand
      voltage_phase_c = rand
      current_phase_a = rand
      current_phase_b = rand
      current_phase_c = rand
      active_energy_phase_a = rand
      active_energy_phase_b = rand
      active_energy_phase_c = rand
      line_to_line_voltage_phase_ab = rand
      line_to_line_voltage_phase_bc = rand
      line_to_line_voltage_phase_ac = rand
      electricity_measurement.id = id
      electricity_measurement.timestamp = time
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
      electricity_measurement.line_to_line_voltage_phase_bc = line_to_line_voltage_phase_bc
      electricity_measurement.line_to_line_voltage_phase_ac = line_to_line_voltage_phase_ac
      json = {
              id: id,
              tsISO8601: wattics_time,
              aP_1: active_power_phase_a,
              aP_2: active_power_phase_b,
              aP_3: active_power_phase_c,
              rP_1: reactive_power_phase_a,
              rP_2: reactive_power_phase_b,
              rP_3: reactive_power_phase_c,
              apP_1: apparent_power_phase_a,
              apP_2: apparent_power_phase_b,
              apP_3: apparent_power_phase_c,
              v_1: voltage_phase_a,
              v_2: voltage_phase_b,
              v_3: voltage_phase_c,
              c_1: current_phase_a,
              c_2: current_phase_b,
              c_3: current_phase_c,
              pC_1: active_energy_phase_a,
              pC_2: active_energy_phase_b,
              pC_3: active_energy_phase_c,
              v_12: line_to_line_voltage_phase_ab,
              v_13: line_to_line_voltage_phase_ac,
              v_23: line_to_line_voltage_phase_bc
              }.to_json
      expect(electricity_measurement.json).to eq json
    end
  end

  let(:dummy_config) { Config.new(nil, nil, nil) }

  context 'PriorityBlockingQueue' do
    it 'should sort' do
      class SortableItem
        attr_accessor :index

        def initialize(index:)
          @index = index
        end

        def <=>(item)
          @index <=> item.index
        end
      end

      queue = PriorityBlockingQueue.new
      queue << SortableItem.new(index: 2)
      queue << SortableItem.new(index: 1)

      expect(queue.pop.index).to be(1)
      expect(queue.pop.index).to be(2)
    end
  end

  context 'Measurements' do
    it 'should send all' do
      count_down_latch = Concurrent::CountDownLatch.new(24)
      agent = Agent.get_instance
      agent.add_measurement_sent_handler do
        lambda { |_measurement, _response|
          count_down_latch.count_down
        }
      end
      electricity_measurement_factory = ElectricityMeasurementFactory.get_instance
      simple_measurement_factory = SimpleMeasurementFactory.get_instance
      measurement_list = []
      12.times do
        measurement_list << electricity_measurement_factory.build
        measurement_list << simple_measurement_factory.build
      end
      agent.send(measurement_list, dummy_config)
      count_down_latch.wait
      expect(count_down_latch.count).to be_equal 0
    end

    it 'should sort before sending' do
      $count_down_latch = Concurrent::CountDownLatch.new(12)
      $sent_measurements = Concurrent::Array.new
      class MockClient
        def send(measurement, _config)
          $sent_measurements << measurement
          $count_down_latch.count_down
          MockResponse.new
        end
      end
      agent = Agent.get_instance
      simple_measurement_factory = SimpleMeasurementFactory.get_instance
      simple_measurement_factory.id = 'channelId'
      measurement_list = []
      hours = 1
      12.times do
        simple_measurement_factory.timestamp = (Time.now - 60 * 60 * hours)
        measurement_list << simple_measurement_factory.build
        hours += 1
      end
      agent.send(measurement_list.reverse, dummy_config)
      $count_down_latch.wait
      measurement_list.sort_by(&:timestamp)
      expect(measurement_list).to match_array($sent_measurements)
    end
  end

  context 'Processor' do
    it 'should not be idle until after it sends last measurement' do
      number_of_measurements_to_send = 1000
      $count_down_latch = Concurrent::CountDownLatch.new(number_of_measurements_to_send)
      class MockClient
        def send(measurement, _config)
          if measurement.id == '0'
            begin
              sleep 0.001
            rescue ThreadError
            end
          end
          $count_down_latch.count_down
          MockResponse.new
        end
      end
      agent = Agent.get_instance(2)
      measurement_factory = SimpleMeasurementFactory.get_instance
      i = 0
      number_of_measurements_to_send.times do
        measurement_factory.id = (i % 3).to_s
        agent.send(measurement_factory.build, dummy_config)
        i += 1
      end
      $count_down_latch.wait
    end

    it 'should work with 500 response' do
      class MockClient
        def send(measurement, _config)
          MockResponse500.new
        end
      end
      agent = Agent.get_instance(2)
      measurement_factory = SimpleMeasurementFactory.get_instance
      agent.send(measurement_factory.build, dummy_config)
      th = Thread.new { agent.wait_until_last }
      sleep 1 #wait for thread to send
      expect(th.status).to be false
    end
  end
end
