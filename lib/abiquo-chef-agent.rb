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

require 'xmlsimple'
require 'json'
require 'time'

module Abiquo
  module Chef
    class Config
      def self.chef_config_dir
        '/etc/chef'
      end

      def self.ntp_server
        'pool.ntp.org'
      end

      def self.log_file
        '/var/log/abiquo-chef-agent.log'
      end

      def self.bootstrap_backup_file
        '/etc/chef/abiquo_bootstrap.xml'
      end

      def self.client_cert_file
        '/etc/chef/client.pem'
      end

      def self.validation_cert
        '/etc/chef/validation.pem'
      end

      def self.bootstrap_mediatype
          'application/vnd.abiquo.bootstrap+xml'
      end

    end

    class BootstrapConfigParser

      attr_reader :node_config, :node_name, :validation_client_name
      attr_reader :chef_server_url, :validation_cert

      #
      # Parses an XML chunk
      #
      # xml: the xml content
      #
      def initialize(xml)
        @raw_xml = xml
        # HACK, FIXME 
        @hash = XmlSimple.xml_in xml.gsub("&#xD;","\n")
        parse
      end

      def parse
        validate
        @node_name = @hash['node'].first
        raise Exception.new("Invalid bootstrap XML. Missing <node> info.") unless @node_name.is_a? String and not @node_name.strip.chomp.empty?

        @node_info = @hash['chef'].first

        @validation_client_name = @node_info['validation-client-name'].first
        raise Exception.new("Invalid bootstrap XML. Missing <validation-client-name> info.") unless @validation_client_name.is_a? String and not @validation_client_name.strip.chomp.empty?

        @validation_cert = @node_info['validation-cert'].first
        raise Exception.new("Invalid bootstrap XML. Missing <validation-cert> info.") unless @validation_cert.is_a? String and not @validation_cert.strip.chomp.empty?

        @chef_server_url = @node_info['chef-server-url'].first
        raise Exception.new("Invalid bootstrap XML. Missing <chef-server-url> info.") unless @chef_server_url.is_a? String and not @chef_server_url.strip.chomp.empty?

        runlist = @node_info['runlist'].first['element']
        attributes = @node_info['attributes'].first unless @node_info['attributes'].nil?
        @node_config = JSON.parse(attributes || '{}')
        @node_config.merge!(JSON.parse("{\"run_list\" : [#{runlist.map{ |r| "\"#{r}\""}.join(',')}]}")) if runlist
      end

      private

      def validate
        raise Exception.new "Invalid bootstrap XML. Missing <node> element." unless @hash.has_key? 'node'
        raise Exception.new "Invalid bootstrap XML. Missing <chef> element." unless @hash.has_key? 'chef'
        raise Exception.new("Invalid bootstrap XML. Missing <chef> info.") if @hash['chef'].empty? or @hash['chef'][0].empty?
        raise Exception.new "Invalid bootstrap XML. Missing <validation-cert> element." unless @hash['chef'].first.has_key? 'validation-cert'
        raise Exception.new "Invalid bootstrap XML. Missing <validation-client-name> element." unless @hash['chef'].first.has_key? 'validation-client-name'
        raise Exception.new "Invalid bootstrap XML. Missing <chef-server-url> element." unless @hash['chef'].first.has_key? 'chef-server-url'
      end

    end

    class Util

      #
      # Tries to find the right leases file
      #
      def self.find_leases_file(search_dirs = ['/var/lib/dhcp3', '/var/lib/dhcp', '/var/lib/dhclient', '/var/lib/NetworkManager'])
        leases = []
        search_dirs.each do |d|
          Dir["#{d}/*"].each do |f|
            next if f !~ /lease(s)?$/
            leases << f
          end
        end
        return leases
      end

      #
      # Returns a Hash representing the leases file
      # {
      #   :ip => ipaddr,
      #   :interface => iface,
      #   :mac => hwmac,
      #   :routers => router_addr,
      #   :domain_name => domain_name,
      #   :abiquo_api_url => url,
      #   :abiquo_api_token => token
      # }
      # 
      def self.parse_leases_file(search_dirs = ['/var/lib/dhcp3', '/var/lib/dhcp', '/var/lib/dhclient', '/var/lib/NetworkManager'])
        files = find_leases_file(search_dirs)
        leases = []
        files.each do |file|
          l = {}
          File.open(file).each { |line|
            case line
            when /^lease \{/
              l = {}
            when /fixed-address (.*);/
              l[:ip] = $1
            when /interface (.*);/
              l[:interface] = $1
            when /hardware ethernet (.*);/
              l[:mac] = $1
            when /option dhcp-server-identifier (.*);/
              l[:dhcp_server] = $1
            when /option routers (.*);/
              l[:routers] = $1
            when /option domain-name (.*);/
              l[:domain_name] = $1
            when /renew \d+ (.+);/
              l[:renew] = Time.parse $1
            when /option vendor-encapsulated-options\s*"(.*)"\s*;/
              tokens = $1.split('@@')
              l[:abiquo_api_url] = tokens[0].gsub("\\", "")
              l[:abiquo_api_token] = tokens[1]
            when /^\}/
              leases << l.clone if l[:abiquo_api_token]
            end
          }.close
        end
        return leases.sort_by { |l| l[:renew] }.last
      end
    end
  end
end

