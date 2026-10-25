# A class-body macro that makes its methods in an `each` or `each_with_index`
# over the names it was given: the loop is unrolled, with the block variable
# and the macro's locals substituted into the methods it generates.
module Declarative
  def my_attr(*names, default: nil, predicate: true)
    names.each do |name|
      define_method(name) { default }
      define_method(:"#{name}=") { |v| @set = v }
      define_method(:"#{name}?") { !!default } if predicate
    end
  end

  def my_forward(*methods, to:)
    methods.each_with_index do |m, i|
      module_eval "def #{m}_fwd(*args, &block); #{to}.#{m}(*args, &block); end"
      module_eval "def #{m}_position; #{i}; end"
    end
  end

  def my_literal
    %w[left right].each do |side|
      define_method("#{side}_side") { side.upcase }
    end
  end
end

class Widget
  extend Declarative

  def initialize
    @items = [3, 1, 2]
  end

  def items
    @items
  end

  my_attr :color, :size, default: 7
  my_attr :mood, predicate: false
  my_forward :first, :sort, :size, to: :items
  my_literal
end

w = Widget.new
p w.color
p w.size
p w.color?
p w.mood
p w.respond_to?(:mood?)
p w.first_fwd
p w.sort_fwd
p w.size_fwd
p w.first_position
p w.size_position
p w.left_side
p w.right_side
