# `include M` runs M's `append_features(base)`, which a module can get from a
# module it extends. Module's own `super` is the plain include; `base < self`
# asks whether the includer already has the module; `base.extend(X)` extends
# the includer. The walk runs it at the `include` statement and the includer
# gets the text it would have run.
module Plugin
  def append_features(base)
    return false if base < self
    super
    base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
    base.module_eval "def plugged_in; true; end"
  end
end

module Fancy
  extend Plugin
  module ClassMethods
    def label; "fancy"; end
  end
  def look; "look"; end
end

module Plain
  extend Plugin
  def plain; "plain"; end
end

class Shop
  include Fancy
  include Plain
  include Fancy
end

s = Shop.new
puts s.look, s.plain, Shop.label
p Shop.include?(Fancy), Shop.include?(Plain), s.plugged_in
