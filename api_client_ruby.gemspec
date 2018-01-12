
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "api_client_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "api_client_ruby"
  spec.version       = ApiClientRuby::VERSION
  spec.authors       = ["Juan Couso"]
  spec.email         = ["juan.couso@gmail.com"]

  spec.summary       = "This gem connects with Wattics API"
  spec.description   = "The gem connects with the wattics API to send over data to the wattics plataform"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir['lib/**/*.rb']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'rest-client', "~> 2.0"
  spec.add_dependency 'json', "~> 2.1"
  spec.add_dependency 'thread', "~> 0.2"
  spec.add_dependency 'concurrent-ruby', "~> 1.0"

end
