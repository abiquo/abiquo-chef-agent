require 'spec_helper'

describe Abiquo::Chef::Config do
  before do
    @config = Abiquo::Chef::Config
  end

  describe "default options" do

    it "should have a valid chef_config_dir" do
      @config.chef_config_dir.should be_a(String)
    end
    
    it "should have a valid ntp_server" do
      @config.ntp_server.should be_a(String)
    end

    it "should have a valid log_file" do
      @config.log_file.should be_a(String)
    end
    
    it "should have a valid bootstrap_backup_file" do
      @config.bootstrap_backup_file.should be_a(String)
    end
    
    it "should have a valid validation_cert" do
      @config.validation_cert.should be_a(String)
    end
    
    it "should have a valid client_cert_file" do
      @config.client_cert_file.should be_a(String)
    end

    it "should have a valid bootstrap xml mediatype" do
      @config.bootstrap_mediatype.should match(/^application\/vnd.abiquo.[a-z]+\+xml(;version=[0-9](\.[0-9]+)+)?$/)
    end

  end
end
