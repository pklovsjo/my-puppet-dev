# == Class: area51_aduser::params
#
class area51_aduser::params {

  $ensure               = 'present'
  $firstname            = 'John'
  $lastname             = 'Doe'
  $fullname             = 'John Doe'
  $accountname          = 'johnd'
  $domainname           = 'area51.local'
  $userpath             = 'OU=Users,OU=France,DC=AREA51,DC=LOCAL'
  $userdescription      = 'John Doe User'
  $emailaddress         = "${accountname}@${domainname}"
  $grouppath            = 'OU=Groups,OU=France,DC=AREA51,DC=LOCAL'
  $groupname            = 'UXjohnd'
  $groupdescription     = 'Private Unix Group of John.D'
  $msSFU30NisDomain     = 'area51'
  $msSFU30Name          = 'johnd'
  $uidNumber            = '30000'
  $gidNumber            = '30000'
  $unixHomeDirectory    = '/home/johnd'
  $loginShell           = '/bin/bash'
  $passwordneverexpires = true
  $passwordlength       = '15'
  $password             = 'M1Gr3atP@ssw0rd'
}
