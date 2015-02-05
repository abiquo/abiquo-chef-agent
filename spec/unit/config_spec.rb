require 'spec_helper'

describe Abiquo::Chef::Config do
  before do
    @config = Abiquo::Chef::Config
  end

  describe "default options" do

    it "should have a valid chef_config_dir" do
      expect(@config.chef_config_dir).to be_a(String)
    end
    
    it "should have a valid ntp_server" do
      expect(@config.ntp_server).to be_a(String)
    end

    it "should have a valid log_file" do
      expect(@config.log_file).to be_a(String)
    end
    
    it "should have a valid bootstrap_backup_file" do
      expect(@config.bootstrap_backup_file).to be_a(String)
    end
    
    it "should have a valid validation_cert" do
      expect(@config.validation_cert).to be_a(String)
    end
    
    it "should have a valid client_cert_file" do
      expect(@config.client_cert_file).to be_a(String)
    end

    it "should have a valid bootstrap xml mediatype" do
      expect(@config.bootstrap_mediatype).to match(/^application\/vnd.abiquo.[a-z]+\+xml(;version=[0-9](\.[0-9]+)+)?$/)
    end

  end
end
