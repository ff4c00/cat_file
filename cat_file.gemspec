$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cat_file/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cat_file"
  s.version     = CatFile::VERSION
  s.authors     = ["ff4c00"]
  s.email       = ["ff4c00@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of CatFile."
  s.description = "Description of CatFile."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.7"
  s.add_dependency 'sass-rails', '~> 5.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-byebug', '~> 2.0'
  s.add_development_dependency 'binding_of_caller'
  
end
