# A macro that evaluates the text it builds on the singleton class
# (`singleton_class.module_eval text`) defines class methods: the text is
# expanded inside `class << self`.
module Builder
  def class_const(name, value)
    singleton_class.module_eval "def #{name}; #{value.inspect}; end"
  end

  def class_pair(a, b)
    singleton_class.module_eval("def #{a}; 1; end; def #{b}; 2; end")
    module_eval "def #{a}_inst; :inst; end"
  end
end

class Settings
  extend Builder
  class_const :host, "localhost"
  class_const :retries, 3
  class_pair :left, :right
end

p Settings.host
p Settings.retries
p Settings.left, Settings.right
p Settings.new.left_inst
p Settings.new.respond_to?(:host)
