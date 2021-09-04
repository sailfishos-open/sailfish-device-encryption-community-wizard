Name:       sailfish-device-encryption-community-wizard

Summary:    Startup Wizard for Sailfish Device Encryption
Version:    0.1
Release:    1
Group:      Qt/Qt
License:    GPLv2
URL:        https://github.com/sailfishos-open/sailfish-device-encryption-community-wizard
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  libsfosdevenc-devel
BuildRequires:  desktop-file-utils
BuildRequires:  cmake

%description
%summary

%prep
%setup -q -n %{name}-%{version}

%build

%cmake . 
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%make_install

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
