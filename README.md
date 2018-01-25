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

Here is some basic commands to get you started with the API. Remember to use a valid username and password. You may send a single measurment or array of measurments. Important: 'wait_until_last' must be include at the end of all the sends to await for all measurments to be sent, missing this command may carry the lost of data.

```ruby
require 'api_client_ruby'
agent = Agent.getInstance

agent.addMeasurementSentHandler do
  -> (measurement, response) {
    puts "#{response.code} - #{measurement}"
  }
end

# config = Config.new(:PRODUCTION, "username", "password");
config = Config.new(:DEVELOPMENT,'username', 'password')

simple_measurement = SimpleMeasurement.new
simple_measurement.id = 'gas-meter-id-01'
simple_measurement.value = 12.3
simple_measurement.timestamp = Time.now
agent.send(simple_measurement, config)


electricity_measurement = ElectricityMeasurement.new
electricity_measurement.id = "elec-meter-id-02"
electricity_measurement.timestamp = Time.now
electricity_measurement.active_energy_phase_a = 5.12
electricity_measurement.active_energy_phase_b = 1.5
# ...
agent.send(electricity_measurement, config);

agent.wait_until_last
```


