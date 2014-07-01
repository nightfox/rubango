lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'totango/version'

Gem::Specification.new do |s|
  s.name         = "rubango"
  s.version      = Totango::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["jonah honeyman", "anirvan mandal"]
  s.email        = ["jonah@honeyman.org", "anirvan.mandal@gmail.com"]
  s.summary      = "API wrapper for Totango tracking integration"
  s.description  = "Enables easy integration of Totango tracking, with options for different ruby web frameworks"
  s.homepage     = "https://github.com/nightfox/rubango"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rubango"

  s.add_development_dependency "pry"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "pry-debugger"
  s.add_development_dependency "rspec"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path = "lib"
end
