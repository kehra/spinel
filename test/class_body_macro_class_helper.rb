# A macro hands the class it expands in (`self`) to a module's helper method
# (`Installer.install(self, name)`), and the helper defines the method on it
# with `owner.module_eval(text)`. The helper is run while the macro expands,
# with the constants it reads, so no run-time reflection is left.
module Installer
  PREFIX = "show_"

  def self.install(owner, name, body)
    owner.module_eval "def #{PREFIX}#{name}; #{body.inspect}; end"
  end

  def self.install_pair(owner, first, second)
    install(owner, first, first.to_s.upcase)
    install(owner, second, second.to_s.upcase)
  end
end

module Declarations
  def shows(name, body)
    Installer.install(self, name, body)
  end

  def shows_pair(first, second)
    Installer.install_pair(self, first, second)
  end
end

class Panel
  extend Declarations
  shows :title, "Hello"
  shows :count, 3
  shows_pair :left, :right
end

class Screen
  extend Declarations
  shows :mode, :dark
end

pa = Panel.new
sc = Screen.new
p pa.show_title, pa.show_count, pa.show_left, pa.show_right
p sc.show_mode
