# == Class: area51_adauth::params
#
class area51_adauth::params {

  $default_realm   = 'AREA51.LOCAL'
  $sdomain         = 'area51.local'
  $kdc             = 'windc01.area51.local'
  $ldapsrv1        = 'windc01.area51.local'
  $ldapsrv2        = 'windc02.area51.local'
}
