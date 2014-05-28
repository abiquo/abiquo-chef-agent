require 'rubygems'
require 'rake'
require './lib/abiquo-chef-agent.rb'
require 'jeweler'
require 'rdoc/task'
require 'rspec/core/rake_task'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.version = Abiquo::Chef::VERSION

  gem.name = "abiquo-chef-agent"
  gem.homepage = "http://github.com/abiquo/abiquo-chef-agent"
  gem.license = "MIT"
  gem.summary = %Q{Abiquo Chef Agent}
  gem.description = %Q{Abiquo Chef Agent}
  gem.email = "ruby-gems@abiquo.com"
  gem.authors = ["Salvador Girones", "Sergio Rubio", "Serafin Sedano", "Ignasi Barrera"]
  gem.add_runtime_dependency 'run-as-root'
  gem.add_runtime_dependency 'chef'
  gem.add_runtime_dependency 'daemons'
  gem.add_runtime_dependency 'rest-client'
  gem.add_runtime_dependency 'xml-simple'
  gem.add_development_dependency 'rspec', '> 1.2.3'
end

Jeweler::RubygemsDotOrgTasks.new

RSpec::Core::RakeTask.new(:spec)

Rake::RDocTask.new do |rdoc|
  version = Abiquo::Chef::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "abiquo-chef-agent #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => [:spec, :build]
