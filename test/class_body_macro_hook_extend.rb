# A module whose `self.included(base)` hook extends the includer with its
# ClassMethods: the class-body macros ClassMethods defines reach the class
# through the include, with no module-specific knowledge in the compiler.
module Mixin
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def tag(name, wrap: "<>")
      define_method("#{name}_tag") { "#{wrap[0]}#{name}#{wrap[1]}" }
    end
  end

  def hello = "hello from #{self.class}"
end

class Page
  include Mixin
  tag :a
  tag :b
end

class Card
  include Mixin
  tag :c, wrap: "[]"
end

pg = Page.new
puts pg.hello
puts pg.a_tag, pg.b_tag
puts Card.new.c_tag
