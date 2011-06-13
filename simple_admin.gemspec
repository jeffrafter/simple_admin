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
end
