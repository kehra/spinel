# A macro that branches on the class of a value it was given
# (`x.is_a?(Symbol)`, `is_a?(Array)`, ...) is decided at expansion time for the
# core classes the evaluator knows.
module Typed
  def describe(name, value)
    kind = "other"
    kind = "symbol" if value.is_a?(Symbol)
    kind = "string" if value.is_a?(String)
    kind = "integer" if value.is_a?(Integer)
    kind = "array" if value.is_a?(Array)
    kind = "nil" if value.is_a?(NilClass)
    module_eval "def #{name}_kind; #{kind.inspect}; end"
  end
end

class Probe
  extend Typed
  describe :a, :sym
  describe :b, "str"
  describe :c, 12
  describe :d, [1, 2]
  describe :e, nil
end

q = Probe.new
p q.a_kind, q.b_kind, q.c_kind, q.d_kind, q.e_kind
