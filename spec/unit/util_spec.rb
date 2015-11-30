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
      expect(@leases).to be_a(Hash)
    end

    it 'should not be empty' do
      expect(@leases).to_not be_empty
    end

    it 'should find a valid ip address' do
      expect(@leases[:ip]).to match(/([0-9]{1,3}\.){3}[0-9]{1,3}/)
    end

    it 'should  have a valid API URL' do
      expect(@leases[:abiquo_api_url]).to match(/http(s)?:\/\//)
    end

    it 'should return latest lease' do
      expect(@leases[:renew]).to eql(Time.parse('2015/11/30 17:28:04 +0100'))
    end

    it 'should  have a valid token' do
      expect(@leases[:abiquo_api_token]).to have_at_least(5).characters
    end

  end

  describe 'find_leases_file' do
    it 'should find a lease file' do
      expect(Util.find_leases_file([data_dir + "dhclient/"])).to have(2).item
    end

    it 'should return an empty list' do
      expect(Util.find_leases_file([])).to have(0).items
      expect(Util.find_leases_file(['/tmp'])).to have(0).items
    end
  end

end
