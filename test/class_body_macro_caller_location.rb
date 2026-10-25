# A macro that records where it was called from
# (`site = caller_locations(1, 1).first`, `site.path`, `site.lineno`) keeps
# expanding: the location is only passed along, never written into the text.
module Located
  def tracked(name, value)
    site = caller_locations(1, 1).first
    file = site.path
    line = site.lineno
    module_eval "def #{name}; #{value.inspect}; end"
  end
end

class Widget
  extend Located
  tracked :alpha, 1
  tracked :beta, "two"
end

w = Widget.new
p w.alpha, w.beta
