# Wattics API Client Ruby

A Ruby client side API that simplifys sending larger amouts of data to Wattics plaform.

## Installation

You will need a local copy of the files. Download them from this repository and install.

```sh
$ git clone git@github.com:Wattics/api-client-ruby.git
$ cd api-client-ruby
$ gem install api_client_ruby
```

## Usage

### Getting started

Here is an example code to get you started with the API. Remember to use a valid username and password. **Important:** `wait_until_last` must be included at the end of all sends, missing this command may carry the lost of data.

```ruby
require 'api_client_ruby'

agent = Agent.get_instance

agent.add_measurement_sent_handler do
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

## Groups of measurments

You may also want send groups of measurments.

```ruby
measurements = [simple_measurement1, electricity_measurement1, simple_measurement2, ...]

agent.send(measurements, config)

agent.wait_until_last
```

```ruby

simple_measurements = [simple_measurement1, simple_measurement2, simple_measurement3, ...]
eletric_measurements = [electric_measurement1, electric_measurement2, electric_measurement3, ..]

agent.send(simple_measurements, config)
agent.send(electric_measurements, config)

agent.wait_until_last
```

## Handlers for callbacks

After sending the data you may want to check if it was sent correcly. For this you have access to `measurment`  and `response`. You can set different handlers for the callbacks using `add_measurement_sent_handler`. You can set as many handles as you like.

Priting to the console and saving a to a file.

```ruby
agent.add_measurement_sent_handler do
  -> (measurement, response) {
    puts "#{response.code} - #{measurement}"
  }
end

agent.add_measurement_sent_handler do
  -> (measurement, response) {
    File.open('results.txt', 'a') do |line|
      line.puts "#{response.code} - #{measurement}"
    end
  }
end
```

## Errors

In case there is an error sending a data, the gem will keep trying until it is sent. Errors will logged to the terminal. See some common erros.

Not register or wrong credentials.
```sh
$ Server Response: HTTP Status 401 - Full authentication is required to access this resource
```

Interet connection down.
```sh
$ Server Response: Failed to open TCP connection to web-collector.wattics.com:443 (getaddrinfo: nodename nor servname provided, or not known)
```



## Parallel Senderes

When running `agent.get_instance`, it will spin twice as many as virtual processors as system has available.
*Ex. If your system is a dual core, and has 4 virtual processors, the gem will spin up 8 parallel send processes for maximum performance.*

In some cases you may want to limit how many processes are created. You can speficy this when creating an instance of the agent. `agent.get_instance(number of processors)`
In case you execed the maximum limit, it will set for to the defult maximum.

```ruby
# Limiting send processes to two.

agent.get_instance(2)
```



