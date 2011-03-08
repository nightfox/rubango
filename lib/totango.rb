lib = File.expand_path('../../lib/', __FILE__) 
$:.unshift(lib) unless $:.include?(lib)

require 'open-uri'
require 'cgi'

require 'totango/config'
require 'totango/client'
require 'totango/arg_parser'
require 'totango/tracker'
require 'totango/adapter'
require 'totango/resource'
require 'totango/adapters/base'
require 'totango/adapters/merb'
require 'totango/adapters/rails'

