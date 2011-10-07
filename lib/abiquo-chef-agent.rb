module Abiquo
  module Chef
    VERSION="1.0.1"

    class Config
      def self.chef_config_dir
        '/etc/chef'
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

    end

    class Util

      #
      # Tries to find the right leases file
      #
      def self.find_leases_file(search_dirs = ['/var/lib/dhcp3', '/var/lib/dhcp', '/var/lib/dhclient'])
        leases = []
        search_dirs.each do |d|
          Dir["#{d}/*"].each do |f|
            mtime = File.mtime f
            if (Time.now - mtime) <= 600
              leases << f
            end
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
      def self.parse_leases_file
        files = find_leases_file
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
            log "Default leases file '#{file}' found"
            return l
          end
        end
        return nil
      end
    end
  end
end
