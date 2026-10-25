# `alias_method m, m` (the same name twice) gives a method no new name, so
# a program that silences redefinition warnings that way still expands its
# class-body macros: the aliased name does not have to be known.
class Module
  def quiet_redefine(name)
    alias_method name, name if method_defined?(name)
  end
end

module Namer
  def name_of(n)
    define_method("#{n}_name") { "name:#{n}" }
  end
end

class Widget
  extend Namer
  name_of :a
  name_of :b
  def a_name2 = "x"
end

w = Widget.new
puts w.a_name, w.b_name, w.a_name2
