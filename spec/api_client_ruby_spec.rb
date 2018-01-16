require 'api_client_ruby'
require 'concurrent'
#require 'pry-byebug'
#require 'spec_helper'


RSpec.describe ApiClientRuby do
  before(:all) do
    class ClientFactory
      def createClient
        MockClient.new
      end
    end
  end

  let(:dummy_config) { Config.new(nil, nil, nil)}
  #let(:agent) { Agent.getInstance }

  # after(:all) do
  #   ClientFactory.setInstance(nil)
  #   Agent.dispose
  # end
  #binding.pry
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
      #binding.pry
      class MockClient
        def send(measurement, config)
          #binding.pry
          $sentMeasurements << measurement
          $countDownLatch.count_down
          nil
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
      #binding.pry
      measurementList.sort_by { |x| x.getTimestamp }
      expect(measurementList).to match_array($sentMeasurements)
    end
  end
end


#     @Test
#     public void testThatMeasurementsAreSortedBeforeBeingSent() throws InterruptedException {
#         CountDownLatch countDownLatch = new CountDownLatch(12);
#         List<Measurement> sentMeasurements = new CopyOnWriteArrayList<>();

#         ClientFactory.setInstance(new ClientFactory() {
#             @Override
#             public Client createClient() {
#                 return new MockClient() {
#                     @Override
#                     public CloseableHttpResponse send(Measurement measurement, Config config) throws IOException {
#                         sentMeasurements.add(measurement);
#                         countDownLatch.countDown();
#                         return super.send(measurement, config);
#                     }
#                 };
#             }
#         });

#         Agent agent = Agent.getInstance();
#         SimpleMeasurementFactory simpleMeasurementFactory = SimpleMeasurementFactory.getInstance();
#         simpleMeasurementFactory.setId("channelId");

#         List<Measurement> measurementList = new ArrayList<>();
#         for (int i = 0; i < 12; i++) {
#             simpleMeasurementFactory.setTimestamp(now().minusHours(i));
#             measurementList.add(simpleMeasurementFactory.build());
#         }

#         agent.send(measurementList, DUMMY_CONFIG);
#         countDownLatch.await();

#         List<Measurement> sortedMeasurements = measurementList
#                 .stream()
#                 .sorted(comparing(measurement -> measurement.timestamp))
#                 .collect(toList());

#         Assert.assertEquals(sortedMeasurements, sentMeasurements);
#     }

#     @Test
#     public void testProcessorIsNotIdleUntilAfterItSendsTheLastMeasurement() throws Exception {
#         int numberOfMeasurementsToSend = 1000;

#         CountDownLatch countDownLatch = new CountDownLatch(numberOfMeasurementsToSend);
#         ClientFactory.setInstance(new ClientFactory() {
#             @Override
#             public Client createClient() {
#                 return new MockClient() {
#                     @Override
#                     public CloseableHttpResponse send(Measurement measurement, Config config) throws IOException {
#                         if (measurement.getId().equals("0")) {
#                             try {
#                                 Thread.sleep(10);
#                             } catch (InterruptedException e) {
#                             }
#                         }
#                         countDownLatch.countDown();
#                         return super.send(measurement, config);
#                     }
#                 };
#             }
#         });

#         Agent agent = Agent.getInstance(2);
#         SimpleMeasurementFactory measurementFactory = SimpleMeasurementFactory.getInstance();
#         for (int i = 0; i < numberOfMeasurementsToSend; i++) {
#             measurementFactory.setId(Integer.toString(i % 3));
#             agent.send(measurementFactory.build(), DUMMY_CONFIG);
#         }

#         countDownLatch.await();
#     }

#     @Test
#     public void main() throws InterruptedException {
#         Agent agent = Agent.getInstance();
#         agent.send(SimpleMeasurementFactory.getInstance().build(), DUMMY_CONFIG);
#     }
# }


