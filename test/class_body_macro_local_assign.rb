# `x ||= v` and `a, b = x, y` over a macro's locals are followed: `||=` takes v
# only when the local is nil or false, and a parallel assignment reads every
# right-hand value before it writes any local.
module Assigner
  def labeled(name, label: nil)
    label ||= name.to_s.upcase
    first, second = label, name.to_s
    first, second = second, first if second.length > first.length
    module_eval "def #{name}_pair; #{[first, second].inspect}; end"
  end

  def counted(name, base = 2)
    lo, hi = base, base + 3
    lo, hi = hi, lo
    module_eval "def #{name}_range; #{[lo, hi].inspect}; end"
  end
end

class Things
  extend Assigner
  labeled :cat
  labeled :dog, label: "doggy"
  labeled :ox, label: "O"
  counted :low
  counted :high, 10
end

t = Things.new
p t.cat_pair, t.dog_pair, t.ox_pair
p t.low_range, t.high_range
