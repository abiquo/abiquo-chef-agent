require 'rubygems'
require 'simplecov'
require 'rspec/collection_matchers'

SimpleCov.start do
  add_filter '/spec/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'abiquo-chef-agent'

module TestHelpersMod
  
  def data_dir
    File.join(File.dirname(__FILE__),"data/")
  end

end
