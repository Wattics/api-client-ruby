# Wattics API Client Ruby

A Ruby client side API that connection with Wattics plataform for sending measuarements or to the platform.

## Installation

You will need a local copy of the files. Download them from this repository and install.

```sh
$ git clone git@github.com:Wattics/api-client-ruby.git
$ cd api-client-ruby
$ gem install api_client_ruby
```

## Usage

### Getting started

Here is an example code to get you started with the API.Remember to use a valid username and password. **Important: 'wait_until_last' must be include at the end of all the sends to await for all measurments to be sent, missing this command may carry the lost of data.**

```ruby
require 'api_client_ruby'

agent = Agent.get_instance

agent.addMeasurementSentHandler do
  -> (measurement, response) {
    puts "#{response.code} - #{measurement}"
  }
end

# config = Config.new(:PRODUCTION, "username", "password")
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
agent.send(electricity_measurement, config)

agent.wait_until_last
```

### Sending arrays of measurments

You may also want send array of measurments of data that has already been collected.

```ruby
measurements = [simple_measurement1, electricity_measurement1, simple_measurement2, ...]

agent.send(measurements, config)
agent.wait_until_last
```
Another example,

```ruby

simple_measurements = [simple_measurement1, simple_measurement2, simple_measurement3, ...]
eletric_measurements = [electric_measurement1, electric_measurement2, electric_measurement3, ..]

agent.send(simple_measurements, config)
agent.send(electric_measurements, config)

agent.wait_until_last
```

## Parallel Senderes

Gem is setup to spin up twice as many as virtual processors as system has available. So if your system is a dual core, and has 4 virtual procesoers, the gem will spin up 8 parrall send processors. They procress will work concurrenly sorting measurments for best performace.

In some cases you may want to limit how many processes are created. You can speficy this when creating an instance of the agent. In case you execed the the maximum, the agent instance will still only have twice as many virtual processors.

```ruby
# agent.get_instance(number_of_processors)
# Example:

agent.get_instance(2)

```



