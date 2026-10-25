# A macro that reads constants the program assigns (`PREFIX`, `STEPS`,
# `Limits::MAX`) keeps expanding: the constant's value is followed, here from
# the module that holds the macro and from another module by its path.
module Limits
  MAX = 3
end

module Accessors
  PREFIX = "get_"
  KINDS = %i[low high].freeze

  def reader(name, kind)
    value = KINDS.include?(kind) ? Limits::MAX : 0
    module_eval "def #{PREFIX}#{name}; #{value}; end"
  end
end

class Meter
  extend Accessors
  reader :speed, :high
  reader :depth, :other
end

m = Meter.new
p m.get_speed, m.get_depth
