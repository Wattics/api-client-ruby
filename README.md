# Api Client Ruby

Ruby client side API that connection with Wattics plataform. You can send simple measuarements or electric measurements.

## Installation

You will need a local copy of the files, download them from this repository.

```sh
$ git clone git@github.com:Wattics/api-client-ruby.git
$ cd api-client-ruby
$ gem install api_client_ruby
```

## Usage

Here is some basic commands to get you started with the API. Remember to use a valid username and password.

```ruby
require 'api_client_ruby'
agent = Agent.getInstance

agent.addMeasurementSentHandler do
  -> (measurement, response) {
    puts measurement
    puts response.code
  }
end

# config = Config.new(:PRODUCTION, "username", "password");
config = Config.new(:DEVELOPMENT,'username', 'password')

simple_measurement = SimpleMeasurement.new
simple_measurement.setId('meter-id-01')
simple_measurement.setValue(12.3)
simple_measurement.setTimestamp(Time.now)
agent.send(simple_measurement, config)

electricity_measurement = ElectricityMeasurement.new
electricity_measurement.setId("meter-id-02");
electricity_measurement.setTimestamp(now());
electricity_measurement.setActivePowerPhaseA(5.12);
electricity_measurement.setActiveEnergyPhaseA(1.5);
# ...
gent.send(electricity_measurement, config);
```
