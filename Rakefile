# Copyright (C) 2008 Abiquo Holdings S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'rake'
require './lib/abiquo-chef-agent.rb'
require 'jeweler'
require 'rdoc/task'
require 'rspec/core/rake_task'

Jeweler::Tasks.new do |gem|
  gem.version = Abiquo::Chef::VERSION
  gem.name = "abiquo-chef-agent"
  gem.homepage = "http://github.com/abiquo/abiquo-chef-agent"
  gem.license = "MIT"
  gem.summary = %Q{Abiquo Chef Agent}
  gem.description = %Q{Abiquo Chef Agent}
  gem.email = "support@abiquo.com"
  gem.authors = ["Salvador Girones", "Sergio Rubio", "Serafin Sedano", "Ignasi Barrera"]
  gem.add_runtime_dependency 'chef'
  gem.add_runtime_dependency 'rest-client', '~> 1.8.0'
  gem.add_runtime_dependency 'xml-simple', '~> 1.1.5'
  gem.add_development_dependency 'jeweler', '~> 2.0.1'
  gem.add_development_dependency 'rspec', '~> 3.2.0'
  gem.add_development_dependency 'rspec-collection-matchers', '~> 1.1.2'
  gem.add_development_dependency 'simplecov', '~> 0.9.1'
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
