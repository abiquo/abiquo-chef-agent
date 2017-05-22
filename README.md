abiquo-chef-agent
=================

A simple boot time execution daemon that allow to execute the Chef configuration of an Abiquo virtual machine.

***The Abiquo Chef agent is required to enable Chef bootstrap features for private cloud in Abiquo < 4.0.2.
Starting from Abiquo 4.0.2 the Chef support is levegared with cloud-init and this agent is no longer required.***

## Installing

Installation script currently targets only CentOS and Ubuntu operating systems. The script will install Chef and
all the agent dependencies. The installation script must be run as root:

    chmod +x install-centos.sh
    ./install-centos.sh

## Building the gem

The build process has been tested on Ruby 2.1.5 and all gem versions have been pinned assuming this. Consider using a Ruby manager or you may have to manually fix some side issues.

    gem build abiquo-chef-agent.gemspec

This will generate the `abiquo-chef-gem` in the current folder.

## Contributing to abiquo-chef-agent
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

See LICENSE for further details.
