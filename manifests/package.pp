# Class: nginx::package
#
# This module manages NGINX package installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package(
  $package_source = 'nginx',
  $package_ensure = 'present',
  $package_path = '/opt/nginx.deb'
) inherits ::nginx::params {

  anchor { 'nginx::package::begin': }
  anchor { 'nginx::package::end': }

  file { $package_path:
    ensure => $package_ensure,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => $package_source,
    notify => Package['nginx']
  }

  package { 'nginx':
    ensure               => installed,
    provider             => dpkg,
    reinstall_on_refresh => true,
    source               => $package_path,
    require              => [File[$package_path], Anchor['nginx::package::begin']],
    before               => Anchor['nginx::package::end'],
  }
}
