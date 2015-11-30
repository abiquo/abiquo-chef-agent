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
require 'rdoc/task'
require 'rspec/core/rake_task'

desc "Build gem"
task :build do  
  system "gem build abiquo-chef-agent.gemspec"
end

desc "Release to rubygems"
task :release => :build do
  system "gem push abiquo-chef-agent-#{Abiquo::Chef::VERSION}"
end

RSpec::Core::RakeTask.new(:spec)

Rake::RDocTask.new do |rdoc|
  version = Abiquo::Chef::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "abiquo-chef-agent #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => [:spec, :build]
