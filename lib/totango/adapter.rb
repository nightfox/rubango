module Totango
  class << self; attr_accessor :adapter end

  class Adapter
    attr_accessor :name, :hook, :action_finder
  end
end


