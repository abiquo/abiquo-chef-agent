lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version.rb'

Gem::Specification.new do |gem|
  gem.version         = Abiquo::Chef::VERSION
  gem.name            = "abiquo-chef-agent"
  gem.homepage        = "http://github.com/abiquo/abiquo-chef-agent"
  gem.license         = "Apache License 2.0"
  gem.summary         = %Q{Abiquo Chef Agent}
  gem.description     = %Q{Abiquo Chef Agent}
  gem.email           = "support@abiquo.com"
  gem.authors         = ["Salvador Girones", "Sergio Rubio", "Serafin Sedano", "Ignasi Barrera"]

  gem.executables     = ["abiquo-chef-run"]
  gem.files           = `git ls-files`.split($/)
  gem.test_files      = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths   = ["lib"]

  gem.add_development_dependency 'rspec', '= 3.2.0'
  gem.add_development_dependency 'rspec-collection_matchers', '= 1.1.2'
  gem.add_development_dependency 'simplecov', '= 0.9.1'
  gem.add_runtime_dependency 'chef'
  gem.add_runtime_dependency 'rest-client', '= 1.8.0'
  gem.add_runtime_dependency 'xml-simple', '= 1.1.5'
end
