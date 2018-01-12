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
config = Config.new(:DEVELOPMENT,'username', 'passoword')
50.times {
  sm = SimpleMeasurement.new
  sm.setId('meter-id' + rand(10).to_s)
  sm.setValue((rand*100).round(3))
  sm.setTimestamp(Time.now)
  sleep(0.001)
  agent.send(sm, config)
}
```
