# == Class: area51_aduser
#
class area51_aduser (

  $ensure               = $area51_aduser::params::ensure,
  $firstname            = $area51_aduser::params::firstname,
  $lastname             = $area51_aduser::params::lastname,
  $fullname             = $area51_aduser::params::fullname,
  $accountname          = $area51_aduser::params::accountname,
  $domainname           = $area51_aduser::params::domainname,
  $userpath             = $area51_aduser::params::userpath,
  $grouppath            = $area51_aduser::params::grouppath,
  $userdescription      = $area51_aduser::params::userdescription,
  $groupdescription     = $area51_aduser::params::groupdescription,
  $emailaddress         = $area51_aduser::params::emailaddress,
  $msSFU30NisDomain     = $area51_aduser::params::msSFU30NisDomain,
  $msSFU30Name          = $area51_aduser::params::msSFU30Name,
  $uidNumber            = $area51_aduser::params::uidNumber,
  $gidNumber            = $area51_aduser::params::gidNumber,
  $unixHomeDirectory    = $area51_aduser::params::unixHomeDirectory,
  $loginShell           = $area51_aduser::params::loginShell,
  $passwordneverexpires = $area51_aduser::params::passwordneverexpires,
  $passwordlength       = $area51_aduser::params::passwordlength,
  $password             = $area51_aduser::params::password,
) inherits area51_aduser::params {

  anchor { 'area51_aduser::begin': } ->
    class { '::area51_aduser::group': } ->
    class { '::area51_aduser::user': } ->
  anchor { 'area51_aduser::end': }

}
