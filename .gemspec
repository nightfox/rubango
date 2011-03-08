lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'saas_pulse/version'

Gem::Specification.new do |s|
  s.name         = "saas_pulse-ruby"
  s.version      = Totango::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["jonah honeyman"]
  s.email        = ["jonah@honeyman.org"]
  s.summary      = "API wrapper for Totango tracking integration"
  s.description  = "Enables easy integration of Totango tracking, with options for different ruby web frameworks"
  s.homepage     = "https://github.com/jonuts/saas_pulse-ruby"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "totango-ruby"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path = "lib"
end
