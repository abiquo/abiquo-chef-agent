# Generated from abiquo-chef-agent-0.1.gem by gem2rpm -*- rpm-spec -*-
%global gemname abiquo-chef-agent

%global gemdir %(ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)
%global geminstdir %{gemdir}/gems/%{gemname}-%{version}
%global rubyabi 1.8

Summary: Abiquo Chef Agent
Name: rubygem-%{gemname}
Version: 0.1
Release: 1%{?dist}
Group: Development/Languages
License: MIT
URL: http://github.com/abiquo/abiquo-chef-agent
Source0: http://gems.rubyforge.org/gems/%{gemname}-%{version}.gem
Requires: ruby(abi) = %{rubyabi}
Requires: ruby(rubygems) 
Requires: ruby 
Requires: rubygem(run-as-root) 
Requires: rubygem(chef) 
Requires: rubygem(rest-client) 
Requires: rubygem(daemons) 
BuildRequires: ruby(abi) = %{rubyabi}
BuildRequires: ruby(rubygems) 
BuildRequires: ruby 
BuildArch: noarch
Provides: rubygem(%{gemname}) = %{version}
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Abiquo Chef Agent


%package doc
Summary: Documentation for %{name}
Group: Documentation
Requires: %{name} = %{version}-%{release}
BuildArch: noarch

%description doc
Documentation for %{name}


%prep
%setup -q -c -T
mkdir -p .%{gemdir}
gem install --local --install-dir .%{gemdir} \
            --bindir .%{_bindir} \
            --force %{SOURCE0}

%build

%install
mkdir -p %{buildroot}%{gemdir}
cp -a .%{gemdir}/* \
        %{buildroot}%{gemdir}/

mkdir -p %{buildroot}%{_bindir}
cp -a .%{_bindir}/* \
        %{buildroot}%{_bindir}/

%{__mkdir_p} %{buildroot}%{_sysconfdir}/rc.d/init.d/
%{__install} -m 755 %{buildroot}%{geminstdir}/scripts/abiquo-chef-agent.init %{buildroot}%{_sysconfdir}/rc.d/init.d/abiquo-chef-agent

find %{buildroot}%{geminstdir}/bin -type f | xargs chmod a+x
#rm  %{buildroot}%{geminstdir}/rubygem-abiquo-chef-agent.spec

%post
/sbin/chkconfig --add abiquo-chef-agent

%preun
if [ $1 -eq 0 ] ; then
    /sbin/service abiquo-chef-agent stop >/dev/null 2>&1
    /sbin/chkconfig --del abiquo-chef-agent
fi

%files
%dir %{geminstdir}
%{_bindir}/abiquo-chef-daemon
%{_bindir}/abiquo-chef-agent
%{geminstdir}/bin
%{geminstdir}/Rakefile
%{geminstdir}/VERSION
%{geminstdir}/lib
%{geminstdir}/scripts/abiquo-chef-agent.init
%{gemdir}/cache/%{gemname}-%{version}.gem
%{gemdir}/specifications/%{gemname}-%{version}.gemspec
%{_sysconfdir}/rc.d/init.d/abiquo-chef-agent


%files doc
%doc %{gemdir}/doc/%{gemname}-%{version}
%doc %{geminstdir}/LICENSE.txt
%doc %{geminstdir}/README.md


%changelog
* Tue Sep 13 2011 Sergio Rubio <rubiojr@frameos.org> - 0.1-1
- Initial package
