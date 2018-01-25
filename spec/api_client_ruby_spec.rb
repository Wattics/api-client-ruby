require 'api_client_ruby'
require 'concurrent'

RSpec.describe ApiClientRuby do
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
      simple_measurement.id(id)
      expect(simple_measurement.id).to be_equal id
    end

    it "should set and return timestamp attibute" do
      time = Time.now
      simple_measurement.timestamp(time)
      expect(simple_measurement.timestamp).to be_equal time
    end

    it "should set and return value attibute" do
      value = rand
      simple_measurement.value(value)
      expect(simple_measurement.value).to be_equal value
    end

    it "should return correct JSON" do
      id = "water-01"
      value = rand
      time = Time.now
      simple_measurement.id(id)
      simple_measurement.value(value)
      simple_measurement.timestamp(time)
      json = "{id: #{simple_measurement.id},
              tsISO8601: #{simple_measurement.timestamp},
              value: #{value}
              }"
      expect(simple_measurement.json).to be_equal json
    end
  end

  context "with ElectricityMeasurement Attributes and JSON" do
    let(:electricity_measurement) { ElectricityMeasurement.new }

    it "should set and return id attibute" do
      id = "elec-meter-01"
      electricity_measurement.id(id)
      expect(electricity_measurement.id).to be_equal id
    end

    it "should set and return timestamp attibute" do
      time = Time.now
      electricity_measurement.timestamp(time)
      expect(electricity_measurement.timestamp).to be_equal time
    end

    it "should set and return active_power_phase_a attibute" do
      active_power_phase_a = rand
      electricity_measurement.active_power_phase_a(active_power_phase_a)
      expect(electricity_measurement.active_power_phase_a).to be_equal active_power_phase_a
    end

    it "should set and return active_power_phase_b attibute" do
      active_power_phase_b = rand
      electricity_measurement.active_power_phase_b(active_power_phase_b)
      expect(electricity_measurement.active_power_phase_b).to be_equal active_power_phase_b
    end

    it "should set and return active_power_phase_c attibute" do
      active_power_phase_c = rand
      electricity_measurement.active_power_phase_c(active_power_phase_c)
      expect(electricity_measurement.active_power_phase_c).to be_equal active_power_phase_c
    end
    # @reactivePowerPhaseA
    # @reactivePowerPhaseB
    # @reactivePowerPhaseC
    # @apparentPowerPhaseA
    # @apparentPowerPhaseB
    # @apparentPowerPhaseC
    # @voltagePhaseA
    # @voltagePhaseB
    # @voltagePhaseC
    # @currentPhaseA
    # @currentPhaseB
    # @currentPhaseC
    # @activeEnergyPhaseA
    # @activeEnergyPhaseB
    # @activeEnergyPhaseC
    # @lineToLineVoltagePhaseAB
    # @lineToLineVoltagePhaseBC
    # @lineToLineVoltagePhaseAC

    # it "should return correct JSON" do
    #   id = "meter-01"
    #   value = rand
    #   time = Time.now
    #   simple_measurement.id(id)
    #   simple_measurement.timestamp(time)
    #   simple_measurement.value(value)

    #   json = "{id: #{simple_measurement.id},
    #           tsISO8601: #{simple_measurement.timestamp},
    #           value: #{value}
    #           }"
    #   expect(simple_measurement.json).to be_equal json
    # end
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
      electricity_measurement_factory = ElectricityMeasurementFactory.getInstance
      simple_measurement_factory = SimpleMeasurementFactory.getInstance
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
      simple_measurement_factory = SimpleMeasurementFactory.getInstance
      simple_measurement_factory.setId('channelId')
      measurement_list = []
      hours = 1
      12.times do
        simple_measurement_factory.setTimestamp(Time.now - 60 * 60 * hours)
        measurement_list << simple_measurement_factory.build
        hours += 1
      end
      agent.send(measurement_list.reverse, dummy_config)
      $count_down_latch.wait
      measurement_list.sort_by(&:getTimestamp)
      expect(measurement_list).to match_array($sent_measurements)
    end
  end

  context 'Processor' do
    it 'should not be idle until after it sends last measurement' do
      number_of_measurements_to_send = 1000
      $count_down_latch = Concurrent::CountDownLatch.new(number_of_measurements_to_send)
      class MockClient
        def send(measurement, _config)
          if measurement.getId == '0'
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
      measurement_factory = SimpleMeasurementFactory.getInstance
      i = 0
      number_of_measurements_to_send.times do
        measurement_factory.setId((i % 3).to_s)
        agent.send(measurement_factory.build, dummy_config)
        i += 1
      end
      $count_down_latch.wait
    end
  end
end
