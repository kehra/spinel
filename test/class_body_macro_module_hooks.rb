# A module whose own methods act as the hooks of every module that extends it:
# `include M` of such a module runs `append_features`, a block handed to
# `included` is kept and evaluated in the includer, `class_methods` builds a
# ClassMethods module, and dependencies between such modules are replayed.
module Kit
  def self.extended(base)
    base.instance_variable_set(:@_deps, [])
  end

  def append_features(base)
    if base.instance_variable_defined?(:@_deps)
      base.instance_variable_get(:@_deps) << self
      false
    else
      return false if base < self
      @_deps.each { |dep| base.include(dep) }
      super
      base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
      base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
    end
  end

  def included(base = nil, &block)
    if base.nil?
      if instance_variable_defined?(:@_included_block)
        raise "multiple included blocks"
      else
        @_included_block = block
      end
    else
      super
    end
  end

  def class_methods(&definition)
    mod = const_defined?(:ClassMethods, false) ?
      const_get(:ClassMethods) :
      const_set(:ClassMethods, Module.new)

    mod.module_eval(&definition)
  end
end

module Greeting
  extend Kit

  included do
    def self.greeting_name = "greeting"
    attr_accessor :tone
  end

  class_methods do
    def make(tone) = new.tap { |o| o.tone = tone }
  end

  def greet = "hello (#{tone})"
end

module Shouting
  extend Kit
  include Greeting

  class_methods do
    def loud = "LOUD"
  end

  def shout = greet.upcase
end

module Plain
  extend Kit
  def plain = "plain"
end

class Speaker
  include Shouting
  include Plain
end

s = Speaker.make("calm")
puts s.greet, s.shout, s.plain
puts Speaker.greeting_name, Speaker.loud
puts Speaker.include?(Greeting), Speaker.include?(Shouting)
