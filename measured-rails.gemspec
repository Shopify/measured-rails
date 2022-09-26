# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'measured/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "measured-rails"
  spec.version       = Measured::Rails::VERSION
  spec.authors       = ["Kevin McPhillips"]
  spec.email         = ["gems@shopify.com"]
  spec.summary       = %q{Rails adaptor for measured}
  spec.description   = %q{Rails adapter for assigning and managing measurements with their units provided by the measured gem.}
  spec.homepage      = "https://github.com/Shopify/measured-rails"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "measured", Measured::Rails::VERSION

  spec.add_runtime_dependency "railties", ">= 5.2"
  spec.add_runtime_dependency "activemodel", ">= 5.2"
  spec.add_runtime_dependency "activerecord", ">= 5.2"

  spec.add_development_dependency "rake", "> 10.0"
  spec.add_development_dependency "minitest", "> 5.5.1"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "mocha", ">= 1.4.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"

  spec.required_ruby_version = ">= 2.7"
end
