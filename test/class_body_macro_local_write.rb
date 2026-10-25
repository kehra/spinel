# A macro that picks a value with an `if` whose arm assigns a local and then
# yields a value (several statements in the arm) is still expanded.
module Picker
  def mode_of(name, loud: false)
    tag = if loud
      mark = name.to_s.length > 1
      mark ? "-loud" : "-short"
    else
      "-calm"
    end
    class_eval "def #{name}_mode; \"#{name}#{tag}\"; end"
  end
end

class Widget
  extend Picker
  mode_of :ab, loud: true
  mode_of :c, loud: true
  mode_of :d
end

w = Widget.new
puts w.ab_mode, w.c_mode, w.d_mode
