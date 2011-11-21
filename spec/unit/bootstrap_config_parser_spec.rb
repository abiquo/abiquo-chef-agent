require 'spec_helper'
include Abiquo::Chef

describe "Bootstrap Config Parser" do
  include TestHelpersMod
  before do
    @cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap.xml"))
  end

  describe "parsing" do
    it "should load a valid bootstrap file" do
      lambda do 
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap.xml"))
      end.should_not raise_error
    end

    it "should raise exception loading invalid bootstrap file" do
      lambda do 
        BootstrapConfigParser.new(File.read(data_dir + "invalid_bootstrap.xml"))
      end.should raise_error
    end
  end

  describe "name" do
    it "should be a string" do
      @cp.node_name.should be_a(String)
    end
    it "should start with ABQ-" do
      @cp.node_name.should match(/^ABQ-/)
    end
  end

  describe "run_list" do
    it "should be an Array" do
      @cp.run_list.should be_a(Array)
    end

    it "should be an empty Array" do
      cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_runlist.xml"))
      cp.run_list.should be_empty
    end

    it "should have a two items in the runlist" do
      @cp.run_list.should have(2).items
    end

    it "should be an array of strings" do
      @cp.run_list.each do |i|
        i.should be_a(String)
      end
    end

    it "should have a recipe and a role" do
      @cp.run_list.first.should match(/role\[/)
      @cp.run_list.last.should match(/recipe\[/)
    end
  end
  
  describe "chef-server-url" do
    it "should be a URL" do
      @cp.chef_server_url.should match(/^http(s)?:\/\//)
    end
  end

  describe "validation-client-name" do
    it "should be a String" do
      @cp.validation_client_name.should be_a(String)
    end
  end

  describe "validation_cert" do
    it 'should start with -----BEGIN RSA PRIVATE KEY' do
      @cp.validation_cert.should match(/^-----BEGIN RSA PRIVATE KEY/)
    end
    it 'should end with END RSA PRIVATE KEY-----' do
      @cp.validation_cert.should match(/END RSA PRIVATE KEY-----$/)
    end
  end

end
