# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "discourse_dev/version"

Gem::Specification.new do |spec|
  spec.name          = "discourse_dev"
  spec.version       = DiscourseDev::VERSION
  spec.authors       = ["Vinoth Kannan"]
  spec.email         = ["svkn.87@gmail.com"]

  spec.summary       = %q{Rake helper tasks for Discourse developers}
  spec.description   = %q{Rake helper tasks for Discourse developers}
  spec.homepage      = "https://github.com/discourse/discourse_dev"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject { |s| s =~ /^(spec)/ }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faker", "~> 2.16"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rubocop-discourse"

  spec.required_ruby_version = '>= 2.6.0'
end
