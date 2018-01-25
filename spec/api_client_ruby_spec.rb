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

  let(:dummy_config) { Config.new(nil, nil, nil) }
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
      agent.send(measurement_list, dummy_config)
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
