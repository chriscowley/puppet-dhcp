# Class dhcp

class dhcp (
  $ensure        = 'running',
  $enable        = true,
  $subnet        = undef,
  $netmask       = undef,
  $domainname    = undef,
  $nameservers   = undef,
  $addressrange  = undef,
  $router        = undef,
  $default-lease = 86400,
  $max-lease     = 604800,
) {
  case $operatingsystem {
    centos, redhat: {
       $dhcp_package = 'dhcp'
    }
    debian, ubuntu: {
      $dhcp_package = 'dhcpd'
    }
  }
  $dhcp_service = 'dhcpd'
  $dhcp_conf    = '/etc/dhcp/dhcpd.conf'


  package { $dhcp_package:
    ensure => latest
  }

  service { $dhcp_service:
    ensure => $ensure,
    enable => $enable,
    hasstatus => true,
    require   => Package[$dhcp_package],
  }
  
  file { $dhcp_conf:
    content => template('dhcp/dhcpd.conf.erb'),
    require => Package[$dhcp_package],
    notify  => Service[$dhcp_service],
  }
}
