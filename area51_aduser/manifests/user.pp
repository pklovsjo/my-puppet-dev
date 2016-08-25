# == Class: aduser::user
#
class area51_aduser::user inherits area51_aduser {
    $ensure               = $area51_aduser::ensure
    $domainname           = $area51_aduser::domainname
    $path                 = $area51_aduser::userpath
    $accountname          = $area51_aduser::accountname
    $lastname             = $area51_aduser::lastname
    $firstname            = $area51_aduser::firstname
    $fullname             = $area51_aduser::fullname
    $emailaddress         = $area51_aduser::emailaddress
    $description          = $area51_aduser::userdescription
    $passwordneverexpires = true
    $passwordlength       = $area51_aduser::passwordlength
    $enabled              = true
    $password             = $area51_aduser::password
    $writetoxmlflag       = true
    $xmlpath              = 'C:\\users.xml'
    $uidNumber            = $area51_aduser::uidNumber
    $gidNumber            = $area51_aduser::gidNumber
    $unixHomeDirectory    = $area51_aduser::unixHomeDirectory
    $loginShell           = $area51_aduser::loginShell
    $msSFU30Name          = $area51_aduser::msSFU30Name
    $msSFU30NisDomain     = $area51_aduser::msSFU30NisDomain

if($ensure == 'present'){
    if(empty($fullname)){
    if(empty($lastname) and !empty($firstname)){
        $fullnamevalue = $firstname
    }
    if(!empty($lastname) and empty($firstname)){
        $fullnamevalue = $lastname
    }
    if(!empty($lastname) and !empty($firstname)){
        $fullnamevalue = "${firstname} ${lastname}"
    }
    }else{
    $fullnamevalue = $fullname
    }

    $modify = false     # will be implement later for modify password. not used for now
      if ($writetoxmlflag == true){
        if (!defined(File[$xmlpath])){
          file{$xmlpath:
            content => template('area51_aduser/xml.erb'),
            replace => no,
        }
      }
    }

    if(!empty($emailaddress)){$emailaddressparam = "-EmailAddress '${emailaddress}'"}
    if(!empty($fullnamevalue)){$fullnameparam = "-DisplayName '${fullnamevalue}'"}
    if(!empty($description)){$descriptionparam = "-Description '${description}'"}
    if(!empty($firstname)){$givenparam = "-GivenName '${firstname}'"}
    if(!empty($lastname)){$lastnameparam = "-SurName '${lastname}'"}

    if(empty($password)){
    $pwd = get_random_password($passwordlength)
    }else{
    $regex = validate_password($password)
    if($regex){
        $pwd = $password
    }else{
        warning('Password is not compliant with complexity policy')
        warning('One integer, one upper, one lower character, one special character, minimun 8 characters long')
        warning('So we will generate one for you ...')
        $pwd = get_random_password($passwordlength)
    }
  }

    $userprincipalname = "${accountname}@${domainname}"

    exec { "Add User - ${accountname}":
    command  => "import-module servermanager;add-windowsfeature -name 'rsat-ad-powershell' -includeAllSubFeature;import-module activedirectory;New-ADUser -name '${fullnamevalue}' -DisplayName '${fullnamevalue}' ${givenparam} ${lastnameparam} ${emailaddressparam} -Samaccountname '${accountname}' -UserPrincipalName '${userprincipalname}' -Description '${description}' -PasswordNeverExpires $${passwordneverexpires} -Path '${path}' -AccountPassword (ConvertTo-SecureString '${pwd}' -AsPlainText -force) -Enabled $${enabled} -OtherAttributes @{uidNumber=${uidNumber};gidNumber=${gidNumber};unixHomeDirectory=('${unixHomeDirectory}');loginShell='${loginShell}';msSFU30Name='${accountname}';msSFU30NisDomain='${msSFU30NisDomain}'};",
    onlyif   => "\$oustring = \"CN=${fullnamevalue},${path}\"; if([adsi]::Exists(\"LDAP://\${oustring}\")){exit 1}",
    provider => powershell,
    }
    if ($writetoxmlflag == true){
    exec { "Add to XML - ${accountname}":
        command  => "[xml]\$xml = New-Object system.Xml.XmlDocument;[xml]\$xml = Get-Content '${xmlpath}';\$subel = \$xml.CreateElement('user');(\$xml.configuration.GetElementsByTagName('users')).AppendChild(\$subel);\$name = \$xml.CreateAttribute('name');\$name.Value = '${accountname}';\$password = \$xml.CreateAttribute('password');\$password.Value = '${pwd}';\$fullname = \$xml.CreateAttribute('fullname');\$fullname.value = '${fullnamevalue}';\$subel.Attributes.Append(\$name);\$subel.Attributes.Append(\$password);\$subel.Attributes.Append(\$fullname);\$xml.save('${xmlpath}');",
        provider => powershell,
        onlyif   => "[xml]\$xml = New-Object system.Xml.XmlDocument;[xml]\$xml = Get-Content '${xmlpath}';\$exist=\$false;foreach(\$user in \$xml.configuration.users.user){if(\$user.name -eq '${accountname}'){\$exist=\$true}}if(\$exist -eq \$True){exit 1}",
        require  => [Exec["Add User - ${accountname}"],File[$xmlpath]],
      }
  }
 }
}
