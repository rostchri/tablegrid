$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tablegrid/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tablegrid"
  s.version     = Tablegrid::VERSION
  s.authors     = ["Christian Rost"]
  s.email       = ["chr@baltic-online.de"]
  s.summary     = "Generic helper for table-grid views."
  s.description = "Generic helper for table-grid views. The original idea comes from http://coryodaniel.com/index.php/2011/02/16/hamlburgerhelper-sets-the-table-easily-create-and-display-standard-tables-in-rails/ or http://dzone.com/snippets/hamlburger-helper-easily"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  %w{ activesupport actionpack railties }.each do |gem|
    s.add_dependency gem, ['>= 3.0.0']
  end
  s.add_dependency "haml"
  %w{ activerecord actionmailer sqlite3 }.each do |gem|
    s.add_development_dependency gem
  end
end
