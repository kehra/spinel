# A class-body macro with a `*rest` parameter: the names the call passes are
# bound to an Array the macro's text can use, after the required and optional
# parameters and with keywords still taken by name.
module Namer
  def name_list(*names, sep: ",")
    module_eval "def listed; #{names.join(sep).inspect}; end"
  end

  def name_count(kind, *names)
    module_eval "def #{kind}_count; #{names.size}; end"
  end

  def name_first(kind, extra = :none, *names)
    module_eval "def #{kind}_first; #{[extra, names.first].inspect.inspect}; end"
  end
end

class Roster
  extend Namer
  name_list :ann, :bob, :cy
end

class Team
  extend Namer
  name_list :dee, sep: "+"
  name_count :member, :ann, :bob
  name_count :empty
  name_first :lead, :x, :y, :z
  name_first :solo
end

puts Roster.new.listed
t = Team.new
puts t.listed
puts t.member_count
puts t.empty_count
puts t.lead_first
puts t.solo_first
