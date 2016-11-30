# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'measured/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "measured-rails"
  spec.version       = Measured::Rails::VERSION
  spec.authors       = ["Kevin McPhillips"]
  spec.email         = ["github@kevinmcphillips.ca"]
  spec.summary       = %q{Rails adaptor for measured}
  spec.description   = %q{Rails adapter for assigning and managing measurements with their units provided by the measured gem.}
  spec.homepage      = "https://github.com/Shopify/measured-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "measured", Measured::Rails::VERSION

  spec.add_runtime_dependency "railties", ">= 4.2"
  spec.add_runtime_dependency "activemodel", ">= 4.2"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5.1"
  spec.add_development_dependency "mocha", "~> 1.1.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"
end
