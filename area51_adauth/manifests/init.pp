# == Class: area51_adauth
#
class area51_adauth (

  $default_realm              = $area51_adauth::params::default_realm,
  $sdomain                    = $area51_adauth::params::sdomain,
  $kdc                        = $area51_adauth::params::kdc,
  $ldapsrv1                   = $area51_adauth::params::ldapsrv1,
  $ldapsrv2                   = $area51_adauth::params::ldapsrv2,
  $servers = [
    {
      fqdn   => $area51_adauth::params::ldapsrv1,
    },
    {
      fqdn   => $area51_adauth::params::ldapsrv2,
    },
  ]
  ) inherits area51_adauth::params {

  Package { ensure => 'installed' }
  package { 'sssd': }
  package { 'krb5-workstation': }

  file {'/etc/sssd/sssd.conf':
    require => Package['sssd'],
    content => template('area51_adauth/sssd.conf.erb'),
    notify  => Service['sssd'],
    mode    => '0600',
  }
  file {'/etc/krb5.conf':
    require => Package['krb5-workstation'],
    content => template('area51_adauth/krb5.conf.erb'),
    mode    => '0644',
  }
  file {'/etc/nsswitch.conf':
    require => Package['sssd'],
    content => template('area51_adauth/nsswitch.conf.erb'),
    mode    => '0644',
  }
  exec { 'update-auth':
    command => '/usr/sbin/authconfig --enablemkhomedir --enablesssdauth --updateall'
  }
  exec { 'update-service':
    command => '/sbin/chkconfig sssd on'
  }
  service { 'sssd':
    ensure    => 'running',
    enable    => true,
    require   => Package['sssd'],
    hasstatus => false,
    status    => '/etc/init.d/sssd status|grep running',
  }
}
