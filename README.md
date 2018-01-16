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

config = Config.new(:DEVELOPMENT,'username', 'password')

sm = SimpleMeasurement.new
sm.setId('meter-id-01')
sm.setValue(12.3)
sm.setTimestamp(Time.now)
agent.send(sm, config)
```
