# A macro that branches on a literal regex tested against a value it was given
# (`/\A[A-Z]/.match?(value.to_s)`): the test runs at expansion time, for the
# plain patterns the evaluator follows (literals, `.`, classes, `* + ?`,
# `^ $ \A \z`).
module Classifier
  def classify(label, value)
    kind = "plain"
    kind = "double-vowel" if /[aeiou][aeiou]/.match?(value.to_s)
    kind = "x-to-y" if /\Ax.*y\z/.match?(value.to_s)
    kind = "number" if /\A[0-9]+\z/.match?(value.to_s)
    kind = "constant" if /\A[A-Z]/.match?(value.to_s)
    module_eval "def #{label}_kind; #{kind.inspect}; end"
  end
end

class Names
  extend Classifier
  classify :a, :Alpha
  classify :b, :beta
  classify :c, :x_marks_y
  classify :d, :tool
  classify :e, "12"
end

n = Names.new
p n.a_kind, n.b_kind, n.c_kind, n.d_kind, n.e_kind
