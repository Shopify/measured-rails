# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "measured-rails"
  spec.version       = "3.0.0"
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

  spec.post_install_message = <<~MSG
    Since version 3.0.0, the functionality of the `measured-rails` gem has been
    merged into the `measured` gem. This gem will no longer be maintained. Please
    remove the gem from your `Gemfile` and replace it with just the `measured` gem.
  MSG

  spec.required_ruby_version = ">= 2.7"
end
