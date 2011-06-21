require 'bundler'
Bundler::GemHelper.install_tasks

ENGINE = "simple_admin"

desc "Creates a sample application using the current Gemfile"
task :sample do

  # Cleanup any existing sample and generate the new application
  FileUtils.rm_rf("spec/sample")
  system "cd spec && rails new sample"

  # Include this engine as a plugin (requires rails/init.rb)
  FileUtils.mkdir_p("spec/sample/vendor/plugins")
  engine_root = File.expand_path(File.dirname(__FILE__))
  system "ln -s #{engine_root} spec/sample/vendor/plugins/#{ENGINE}"

  # Go to the sample
  Dir.chdir "spec/sample"

  # Generate our initializer into the sample application
  system "rails g #{ENGINE}"

  # Make a place and a thing
  system "rails g scaffold place name:string"
  system "rails g scaffold thing name:string happy:boolean age:integer place_id:integer"

  # Add relations to the declarations
  system "echo 'class Place < ActiveRecord::Base; has_many :things; end;' > app/models/place.rb"
  system "echo 'class Thing < ActiveRecord::Base; belongs_to :place; end;' > app/models/thing.rb"

  # Manually add a route
  puts "Adding test routes..."
  routes = File.read("config/routes.rb")
  routes.gsub!(/^end$/, "\n\n  resources :admins, :controller => 'simple_admin/admin'\nend")
  File.open("config/routes.rb", "w") { |f| f.write routes }

  # We need testing gems and kaminari and formtastic by default
  ['kaminari', 'formtastic', 'rspec-rails', 'mocha', 'shoulda', 'factory_girl', 'capybara'].each do |gem|
    system "echo 'gem \"#{gem}\"' >> Gemfile"
  end

  # If we are not on 1.9.x we need fastercsv
  system "echo 'gem \"fastercsv\"' >> Gemfile" if RUBY_VERSION =~ /^1.8/

  # To work with Rails 3.1.x we need the latest meta_search
  system "echo 'gem \"meta_search\", \">= 1.1.0.pre\"' >> Gemfile"

  # With more gems, comes more bundling
  system "bundle"

  # Make an admin interface
  system "echo 'SimpleAdmin.register :thing do; end' > app/admin/things.rb"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec
