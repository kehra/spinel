# A macro changing a local array in place (`parts << x`) is followed: the text it builds
# sees the array after the change, as at run time.
module Consts
  def constant(c)
    parts = ["calc", "box"]
    parts << "x"
    const_set(c, public_send((parts + [c.to_s.downcase]).join("_")))
  end
end
class Calc
  extend Consts
  def self.calc_box_size = 1
  def self.calc_box_x_size = 2
  constant :SIZE
end
p Calc::SIZE
