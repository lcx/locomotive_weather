# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locomotive_weather/version'

Gem::Specification.new do |spec|
  spec.name          = "locomotive_weather"
  spec.version       = LocomotiveWeather::VERSION
  spec.authors       = ["Cristian Livadaru"]
  spec.email         = ["cristian@lcx.at"]
  spec.description   = %q{Add a weather liquid tag for Locomotive CMS}
  spec.summary       = %q{weather tag}
  spec.homepage      = "https://github.com/lcx/locomotive_weather"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'locomotive_liquid',     '~> 2.4.2'
  spec.add_runtime_dependency 'wunderground', '1.0.0'
end
