require 'api_client_ruby'
require 'concurrent'

RSpec.describe ApiClientRuby do
  before(:all) do
    class ClientFactory
      def createClient
        MockClient.new
      end
    end
  end

  let(:dummy_config) { Config.new(nil, nil, nil)}
  context "Measurements" do
    it "should send all" do
      countDownLatch = Concurrent::CountDownLatch.new(24)
      agent = Agent.getInstance
      agent.addMeasurementSentHandler do
        -> (measurement, response) {
          countDownLatch.count_down
        }
      end
      electricityMeasurementFactory = ElectricityMeasurementFactory.getInstance
      simpleMeasurementFactory = SimpleMeasurementFactory.getInstance
      measurementList = []
      12.times {
        measurementList << electricityMeasurementFactory.build
        measurementList << simpleMeasurementFactory.build
      }
      agent.send(measurementList, dummy_config)
      countDownLatch.wait()
      expect(countDownLatch.count).to be_equal 0
    end

    it "should sort before sending" do
      $countDownLatch = Concurrent::CountDownLatch.new(12)
      $sentMeasurements =  Concurrent::Array.new
      class MockClient
        def send(measurement, config)
          $sentMeasurements << measurement
          $countDownLatch.count_down
          MockResponse.new
        end
      end
      agent = Agent.getInstance
      simpleMeasurementFactory = SimpleMeasurementFactory.getInstance
      simpleMeasurementFactory.setId("channelId")
      measurementList = []
      hours = 1
      12.times {
        simpleMeasurementFactory.setTimestamp(Time.now - 60*60*hours)
        measurementList << simpleMeasurementFactory.build
        hours += 1
      }
      agent.send(measurementList, dummy_config)
      $countDownLatch.wait();
      measurementList.sort_by { |x| x.getTimestamp }
      expect(measurementList).to match_array($sentMeasurements)
    end
  end

  context "Processor" do
    it "should not be idle until after it sends last measurement" do
      numberOfMeasurementsToSend = 1000
      $countDownLatch = Concurrent::CountDownLatch.new(numberOfMeasurementsToSend)
      class MockClient
        def send(measurement, config)
          if measurement.getId == "0"
            begin
              sleep 0.001
            rescue ThreadError
            end
          end
          $countDownLatch.count_down
          MockResponse.new
        end
      end
      agent = Agent.getInstance(2)
      measurementFactory = SimpleMeasurementFactory.getInstance
      i = 0
      numberOfMeasurementsToSend.times {
        measurementFactory.setId((i%3).to_s)
        agent.send(measurementFactory.build, dummy_config)
        i += 1
      }
      $countDownLatch.wait()
    end
  end
end



