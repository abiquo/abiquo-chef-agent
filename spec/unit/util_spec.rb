require 'spec_helper'
require 'time'
include Abiquo::Chef

describe Util do
  include TestHelpersMod

  before do
    @leases = Util.parse_leases_file([data_dir + "dhclient/"])
  end

  describe 'parse_leases_file' do
    it 'parse leases file without error' do
      @leases.should be_a(Hash)
    end

    it 'should not be empty' do
      @leases.should_not be_empty
    end

    it 'should find a valid ip address' do
      @leases[:ip].should match(/([0-9]{1,3}\.){3}[0-9]{1,3}/)
    end

    it 'should  have a valid API URL' do
      @leases[:abiquo_api_url].should match(/http(s)?:\/\//)
    end

    it 'should return latest lease' do
      @leases[:renew].should eql(Time.parse('2012-11-18 05:48:45 +0100'))
    end

    it 'should  have a valid token' do
      @leases[:abiquo_api_token].should have_at_least(5).characters
    end

  end

  describe 'find_leases_file' do
    it 'should find a lease file' do
      Util.find_leases_file([data_dir + "dhclient/"]).should have(1).item
    end

    it 'should return an empty list' do
      Util.find_leases_file([]).should have(0).items
      Util.find_leases_file(['/tmp']).should have(0).items
    end
  end

end
