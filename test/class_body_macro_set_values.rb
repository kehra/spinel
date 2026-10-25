# A macro that checks a name against a list or a Set it holds
# (`names.include?(x)`, `names.to_set.include?(x)`) and freezes what it
# builds: the membership test is decided at expansion time.
require "set"

module Gatekeeper
  def gate(name, kind)
    allowed = %i[read write].freeze
    flags = %w[bold italic].to_set
    mode = allowed.include?(kind) ? "allowed" : "denied"
    style = flags.include?(name.to_s) ? "styled" : "plain"
    text = "#{mode}-#{style}".freeze
    module_eval "def #{name}_gate; #{text.inspect}; end"
  end
end

class Door
  extend Gatekeeper
  gate :bold, :read
  gate :plain, :write
  gate :italic, :admin
  gate :other, :admin
end

d = Door.new
p d.bold_gate, d.plain_gate, d.italic_gate, d.other_gate
