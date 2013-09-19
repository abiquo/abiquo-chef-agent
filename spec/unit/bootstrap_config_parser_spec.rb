require 'spec_helper'
include Abiquo::Chef

describe "Bootstrap Config Parser" do
  include TestHelpersMod
  before do
    @cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap.xml"))
  end

  describe "parsing" do
    it "should load a valid bootstrap file" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap.xml"))
      }.to_not raise_error
    end

    it "should raise exception loading invalid bootstrap file" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "invalid_bootstrap.xml"))
      }.to raise_error
    end

    it "should raise exception loading invalid bootstrap file missing validation" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_missing_validation.xml"))
      }.to raise_error /Missing <validation-client-name> element/
    end

    it "should raise exception loading invalid bootstrap file missing server url" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_missing_server_url.xml"))
      }.to raise_error /Missing <chef-server-url> element/
    end

    it "should raise exception loading invalid bootstrap file missing node" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_missing_node.xml"))
      }.to raise_error /Missing <node> element/
    end

    it "should raise exception loading invalid bootstrap file missing chef" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_missing_chef.xml"))
      }.to raise_error /Missing <chef> element/
    end

    it "should raise exception loading invalid bootstrap file missing cert" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_missing_cert.xml"))
      }.to raise_error /Missing <validation-cert> element/
    end

    it "should raise exception loading invalid bootstrap file empty validation" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_validation.xml"))
      }.to raise_error /Missing <validation-client-name> info/
    end

    it "should raise exception loading invalid bootstrap file empty server url" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_server_url.xml"))
      }.to raise_error /Missing <chef-server-url> info/
    end

    it "should raise exception loading invalid bootstrap file empty node" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_node.xml"))
      }.to raise_error /Missing <node> info/
    end

    it "should raise exception loading invalid bootstrap file empty chef" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_chef.xml"))
      }.to raise_error /Missing <chef> info/
    end

    it "should raise exception loading invalid bootstrap file empty cert" do
      expect {
        BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_cert.xml"))
      }.to raise_error /Missing <validation-cert> info/
    end


    describe "name" do
      it "should be a string" do
        @cp.node_name.should be_a(String)
      end
      it "should start with ABQ-" do
        @cp.node_name.should match(/^ABQ-/)
      end
    end

    describe "node_config" do
      it "should be a Hash" do
        @cp.node_config.should be_a(Hash)
      end

      it "runlist should be an empty missing" do
        cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_runlist.xml"))
        expect(cp.node_config).not_to have_key("run_list")
      end

      it "should have three elements" do
        @cp.node_config.should have(3).items
      end

      it "runlist should have a two items in the runlist" do
        @cp.node_config["run_list"].should have(2).items
      end

      it "should be an array of strings" do
        @cp.node_config["run_list"].each do |i|
          i.should be_a(String)
        end
      end

      it "should have a recipe and a role" do
        @cp.node_config["run_list"].first.should match(/role\[/)
        @cp.node_config["run_list"].last.should match(/recipe\[/)
      end

      it "should contains boundary and newrelic" do
        expect(@cp.node_config).to have_key("boundary")
        expect(@cp.node_config).to have_key("newrelic")
      end

      it "attributes should be missing" do
        cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap_no_attributes.xml"))
        expect(cp.node_config).not_to have_key("boundary")
        expect(cp.node_config).not_to have_key("newrelic")
        expect(cp.node_config).to have_key("run_list")
      end

      it "attributes should be missing" do
        cp = BootstrapConfigParser.new(File.read(data_dir + "bootstrap_empty_runlist_no_attributes.xml"))
        cp.node_config.size.should be(0)
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
end
