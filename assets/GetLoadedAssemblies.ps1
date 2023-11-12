$dlls1 = [System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    if ($_.Location)
    {
        Split-Path -Path $_.Location -Leaf
    }
}

Import-Module -Name Az.Accounts

$dlls2 = [System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    if ($_.Location)
    {
        Split-Path -Path $_.Location -Leaf
    }
}

Compare-Object -ReferenceObject $dlls1 -DifferenceObject $dlls2