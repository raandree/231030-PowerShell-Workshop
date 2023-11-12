Add-Type -AssemblyName System.DirectoryServices.AccountManagement

$ctx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new('Domain')

[System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($ctx, 'install')