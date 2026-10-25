# `extend M` runs M's `def self.extended(base)` at the statement. What the
# hook does to the class it was given -- `base.instance_variable_set` and
# `base.instance_variable_get(:@x) << v` -- is followed, so the class-body
# macros that come after read the values the run would give them.
module Tagging
  def self.extended(base)
    base.instance_variable_set(:@tags, [:first])
    base.instance_variable_get(:@tags) << :second
  end

  def tag(name)
    @tags = instance_variable_get(:@tags) + [name]
    module_eval "def has_#{name}?; true; end"
  end

  def tags_method
    tags = instance_variable_get(:@tags)
    module_eval "def tags; #{tags.inspect}; end"
  end
end

class Widget
  extend Tagging
  tag :third
  tag :fourth
  tags_method
end

class Gadget
  extend Tagging
  tags_method
end

w = Widget.new
p w.tags, w.has_third?, w.has_fourth?
p Gadget.new.tags
