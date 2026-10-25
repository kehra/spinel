# A macro that asks the module it expands in about itself --
# `instance_variable_defined?` / `instance_variable_get` for what earlier
# macros kept, `const_defined?` / `const_get` for the constants it has -- and
# that builds a nested module with `const_set(:X, Module.new)` is expanded:
# each answer is the one the run would give.
module Registry
  def remember(name)
    if instance_variable_defined?(:@names)
      @names = instance_variable_get(:@names) + [name]
    else
      @names = [name]
    end
    module_eval "def #{name}_noted; true; end"
  end

  def report
    names = instance_variable_get(:@names)
    has_helpers = const_defined?(:Helpers)
    has_nope = const_defined?(:NOPE)
    module_eval "def summary; [#{names.inspect}, #{has_helpers}, #{has_nope}]; end"
  end

  def section(label, &definition)
    mod = const_defined?(:Parts, false) ? const_get(:Parts) : const_set(:Parts, Module.new)
    mod.module_eval(&definition)
    module_eval "def #{label}_section; #{label.to_s.inspect}; end"
  end
end

class Catalog
  module Helpers; end
  extend Registry
  remember :a
  remember :b
  remember :c
  report
  section :top do
    def depth; 4; end
  end
  section :more do
    def width; 9; end
  end
end

c = Catalog.new
p c.summary, c.a_noted
p c.top_section, c.more_section

class Probe
  include Catalog::Parts
end
pr = Probe.new
p pr.depth, pr.width
