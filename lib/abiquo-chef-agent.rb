require 'xmlsimple'

module Abiquo
  module Chef

    VERSION="1.0.7"

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

    end

    class BootstrapConfigParser

      attr_reader :run_list, :node_name, :validation_client_name
      attr_reader :chef_server_url, :validation_cert

      #
      # Parses an XML chunk
      #
      # xml: the xml content
      #
      def initialize(xml)
        @raw_xml = xml
        #
        # HACK, FIXME 
        #
        @hash = XmlSimple.xml_in xml.gsub("&#xD;","\n")
        parse
      end

      def parse
        @node_name = @hash['node'].first
        if not @node_name or @node_name.strip.chomp.empty?
          raise Exception.new("Invalid bootstrap XML. Missing <node> info.")
        end

        @node_info = @hash['chef'].first
        if not @node_info
          raise Exception.new("Invalid bootstrap XML. Missing <chef> info.")
        end

        @validation_client_name = @node_info['validation-client-name'].first
        if not @validation_client_name or @validation_client_name.strip.chomp.empty?
          raise Exception.new("Invalid bootstrap XML. Missing <validation-client-name> info.")
        end

        @validation_cert = @node_info['validation-cert'].first
        if not @validation_cert or @validation_cert.strip.chomp.empty?
          raise Exception.new("Invalid bootstrap XML. Missing <validation-cert> info.")
        end
        @chef_server_url = @node_info['chef-server-url'].first
        if not @chef_server_url or @chef_server_url.strip.chomp.empty?
          raise Exception.new("Invalid bootstrap XML. Missing <chef-server-url> info.")
        end
        @run_list = @node_info['runlist'].first['element'] || []
      end

    end

    class Util

      #
      # Tries to find the right leases file
      #
      def self.find_leases_file(search_dirs = ['/var/lib/dhcp3', '/var/lib/dhcp', '/var/lib/dhclient'])
        leases = []
        search_dirs.each do |d|
          Dir["#{d}/*"].each do |f|
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
      def self.parse_leases_file(search_dirs = ['/var/lib/dhcp3', '/var/lib/dhcp', '/var/lib/dhclient'])
        files = find_leases_file(search_dirs)
        files.each do |file|
          f = File.open(file)
          l = {}
          f.each do |line|
            case line
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
            when /option vendor-encapsulated-options\s*"(.*)"\s*;/
              tokens = $1.split('@@')
              l[:abiquo_api_url] = tokens[0].gsub("\\", "")
              l[:abiquo_api_token] = tokens[1]
            end
          end
          if l[:abiquo_api_token]
            return l
          end
        end
        return nil
      end
    end
  end
end
