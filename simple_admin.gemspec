# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_admin/version"

Gem::Specification.new do |s|
  s.name        = "simple_admin"
  s.version     = SimpleAdmin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Rafter"]
  s.email       = ["jeffrafter@gmail.com"]
  s.homepage    = "http://github.com/jeffrafter/simple_admin"
  s.summary     = %q{Simple administrative interfaces for data in your rails application}
  s.description = %q{Use SimpleAdmin to build out filtering, searchable, editable interfaces for your models}

  s.rubyforge_project = "simple_admin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("rails", [">= 3.1.0rc4"])
  s.add_runtime_dependency("kaminari", [">= 0"])
  s.add_runtime_dependency("formtastic", [">= 0"])
  s.add_runtime_dependency("meta_search", [">= 1.1.0.pre"])

  s.add_development_dependency("rspec", [">= 2.6.0"])
  s.add_development_dependency("rspec-rails", [">= 2.6.0"])
  s.add_development_dependency("shoulda", [">= 0"])
  s.add_development_dependency("factory_girl", [">= 0"])
  s.add_development_dependency("mocha", ["> 0"])
  s.add_development_dependency("capybara", [">= 0.4.0"])
  s.add_development_dependency("sqlite3-ruby")
end
