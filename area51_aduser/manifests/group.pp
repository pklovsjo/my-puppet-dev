# == Class: area51_aduser::group
#
class area51_aduser::group inherits area51_aduser {

  $ensure           = $area51_aduser::ensure                # Add or delete user
  $path             = $area51_aduser::grouppath             # Where is located the account
  $displayname      = $area51_aduser::displayname           # The displayname
  $groupname        = $area51_aduser::groupname             # Is name powersherll parameter
  $groupscope       = 'Global'                              # Is groupscope (DomainLocal  OR  Global  OR  Universal )
  $groupcategory    = 'Security'                            # Is groupcategory ( Security  OR Distribution  )
  $description      = $area51_aduser::groupdescription      # Description of group
  $confirmdeletion  = false                                 # Delete without confirmation
  $msSFU30NisDomain = $area51_aduser::msSFU30NisDomain      # NIs Domain
  $gidNumber        = $area51_aduser::gidNumber             # Group ID i.e. 30000


  validate_re($ensure, '^(present|absent)$', 'valid values for ensure are \'present\' or \'absent\'')
  validate_re($groupscope, '^(DomainLocal|Global|Universal)$', 'valid values for groupscope are \'DomainLocal\' or \'Global\' or \'Universal\'')
  validate_re($groupcategory, '^(Security|Distribution)$', 'valid values for groupcategory are \'Security\' or \'Distribution\'')

  if($ensure == 'present'){
    exec { "Add Group - ${groupname}":
      command  => "Import-module Activedirectory;New-ADGroup -Description '${description}' -DisplayName '${displayname}' -Name '${groupname}' -GroupCategory '${groupcategory}' -GroupScope '${groupscope}' -Path '${path}' -OtherAttributes @{msSFU30NisDomain='${msSFU30NisDomain}';gidNumber='${gidNumber}'} ",
      onlyif   => "\${groupname} = \"${groupname}\";\${path} = \"${path}\";\${oustring} = \"CN=\${groupname},\${path}\"; if([adsi]::Exists(\"LDAP://\${oustring}\")){exit 1}",
      provider => powershell,
    }
  }else{
    exec { "Remove Group - ${groupname}":
      command  => "import-module activedirectory;Remove-ADGroup -identity '${groupname}' -confirm:$${confirmdeletion}",
      onlyif   => "\$groupname = \"${groupname}\";\$path = \"${path}\";\$oustring = \"CN=\$groupname,\$path\"; if([adsi]::Exists(\"LDAP://\$oustring\")){}else{exit 1}",
      provider => powershell,
    }
  }
}
