$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tablegrid/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tablegrid"
  s.version     = Tablegrid::VERSION
  s.authors     = ["Christian Rost"]
  s.email       = ["chr@baltic-online.de"]
  s.summary     = "Generic helper for table-views."
  s.description = "TODO: Detailed Description of Tablegrid."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
end
