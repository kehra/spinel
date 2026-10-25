# A macro that takes the block of its call (`def scoped(label, &blk)`) and
# evaluates it in a module's body (`class_eval(&blk)`,
# `owner.module_eval(&blk)`) is expanded: the block's body is the text that
# lands in that body, beside whatever else the macro defines.
module Scoped
  def scoped(label, &blk)
    class_eval(&blk)
    module_eval "def #{label}_scope; #{label.to_s.inspect}; end"
  end

  def scoped_in(label, &blk)
    owner = self
    owner.module_eval(&blk)
    owner.module_eval "def #{label}_owned; true; end"
  end
end

class Panel
  extend Scoped

  scoped :top do
    def width; 80; end
    def height; 24; end
  end

  scoped_in :side do
    def margin; 2; end
  end
end

pa = Panel.new
p pa.width, pa.height, pa.top_scope
p pa.margin, pa.side_owned
