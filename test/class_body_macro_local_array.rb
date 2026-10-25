# A macro that collects the text of its methods in a local Array (`<<`, `push`,
# `append`, chained) and evaluates it once, joined, when the Array is not
# empty.
module Collector
  def collect(a, b)
    texts = []
    texts << "def #{a}_one; 1; end" << "def #{a}_two; 2; end"
    texts.push("def #{b}_three; 3; end", "def #{b}_four; 4; end")
    texts.append("def #{a}#{b}_five; 5; end")
    module_eval texts.join("\n") unless texts.empty?
  end

  def collect_none(name)
    texts = []
    module_eval "def #{name}_bad; 1; end" unless texts.empty?
    module_eval "def #{name}_none; #{texts.empty?}; end"
  end
end

class Parts
  extend Collector
  collect :x, :y
  collect_none :z
end

o = Parts.new
p [o.x_one, o.x_two, o.y_three, o.y_four, o.xy_five]
p o.z_none
p o.respond_to?(:z_bad)
