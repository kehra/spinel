# A macro the program gives to Class, Module or Object itself (no extend): every
# class body can call it, as the reopened method can at run time.
class Class
  def my_reader(name, default: nil)
    define_method(name) { default }
  end
end

class Module
  def my_delegate(method, to:, prefix: nil)
    name = prefix ? "#{prefix}_#{method}" : method.to_s
    module_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{name}(*args, &block)
        #{to}.#{method}(*args, &block)
      end
    RUBY
  end
end

class Object
  def my_flag(name, on: false)
    class_eval "def #{name}?; #{on}; end"
  end
end

class Config
  my_reader :host, default: "localhost"
  my_reader :port, default: 3
  my_flag :debug, on: true
end

class Bag
  def initialize
    @list = [4, 5, 6]
  end

  def list
    @list
  end

  my_delegate :size, to: :list
  my_delegate :first, to: :list
  my_delegate :last, to: :list, prefix: "bag"
end

module Toolbox
  my_delegate :upcase, to: "'tool'"
end

c = Config.new
p c.host
p c.port
p c.debug?
bag = Bag.new
p bag.size
p bag.first
p bag.bag_last
class Holder
  include Toolbox
end
p Holder.new.upcase
