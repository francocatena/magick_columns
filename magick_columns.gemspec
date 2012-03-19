$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "magick_columns/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "magick_columns"
  s.version     = MagickColumns::VERSION
  s.authors     = ["Franco Catena"]
  s.email       = ["francocatena@gmail.com"]
  s.homepage    = "http://github.com/francocatena/magick_columns"
  s.summary     = "Build query conditions from simple strings"
  s.description = "Tokenize a simple strings and builds an ActiveRecord query"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "timeliness", "~> 0.3"

  s.add_development_dependency "pg"
end
